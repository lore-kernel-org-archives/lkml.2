Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0GIGY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:24:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0GIGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=eDjPQx6YFzT3QdjvdWJgJhODwEAn0FEe7XUMNWkCZUE9CXyDZPw813mthRWf0XATR3
         2N2kUMNtdhvoKtWoTiFU29D/5IKxIxrVWXOeSL0wOI9MqOmTk2xlhHk53REYP/VU28Jd
         O2QEJYjMuwCeVx1qVO7oG19v0Yt9MRlgSGPAM=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #16256] tpm_tis breaks suspend/hibernate on kernels > 2.6.34
Date: Fri, 9 Jul 2010 08:23:47 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc3-wl-default+; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "David Safford" <safford@watson.ibm.com>,
       "James Morris" <jmorris@namei.org>,
       "Rajiv Andrade" <srajiv@linux.vnet.ibm.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.QYC.1MmNMB@chimera>
In-Reply-To: <TXb9XdQzJoD.A.QYC.1MmNMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007090823.47530.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 09 Juli 2010 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16256
> Subject		: tpm_tis breaks suspend/hibernate on kernels > 2.6.34
> Submitter	: Helmut Schaa <helmut.schaa@googlemail.com>
> Date		: 2010-06-20 11:15 (19 days old)
> First-Bad-Commit: http://git.kernel.org/linus/225a9be24d799aa16d543c31fb09f0c9ed1d9caa
> Handled-By	: Helmut Schaa <helmut.schaa@googlemail.com>
> Patch		: http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2

Seems like the patch didn't make it into mainline yet. So I guess it should
still be listed here.

Helmut
