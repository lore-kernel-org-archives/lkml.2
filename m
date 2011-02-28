Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1B1LjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:39:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59655 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1B1LjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=tlvi9zpolhAnmknXVeOzziidb9PWATc08bDqYNx5VU+K9RI2dgi6///dJQ/Mr8j4m3
         Qo22quseKAodKWsOibEO3AB6tqykZvhQI/TDUUsvjmwvKkj2zSszZi3V0xJsGgPEqKBM
         MUrwz2HHYhhHGL/5I6ygV6X0x+TICyISgMwMk=
MIME-Version: 1.0
In-Reply-To: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org>
References: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 28 Feb 2011 12:39:02 +0100
X-Google-Sender-Auth: k5qlw7HAGLBtNBFG_cibCqlfWE8
Message-ID: <AANLkTimDu-KFFfvWd95URQJMt2YbWU9tLwzNeE2Lf4OW@mail.gmail.com>
Subject: Re: [PATCH 0/5] target updates for scsi-post-merge .39 (round one)
To: linux-iscsi-target-dev@googlegroups.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Joel Becker <jlbec@evilplan.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 7:20 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Patches #1 -> #4 involve the addition of new ConfigFS context based
> statistics groups in target_core_stat.c following RFC-4455 to address
> the removal of the legacy ProcFS based target_core_mib.c in .38 code.

Hot-pluggable InfiniBand HCAs are available since some time. As I
wrote before, exporting RFC-4455 data via configfs instead of sysfs
makes implementing RFC 4455 in a (user space) SNMP agent overly
complex.

Bart.
