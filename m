Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2BOXrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:47:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59706 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2BOXrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:47:09 -0500
MIME-Version: 1.0
In-Reply-To: <1329230947-27675-1-git-send-email-danny.kukawka@bisect.de>
References: <1329230947-27675-1-git-send-email-danny.kukawka@bisect.de>
Date: Wed, 15 Feb 2012 15:47:08 -0800
X-Google-Sender-Auth: -vbTpXtYkXRQz_JaSaCxPogWdms
Message-ID: <CAA9_cmf2fqobuHqgKPHQ9Eb=MRiGkM=br3=Cfvxpxdn-9L5VyQ@mail.gmail.com>
Subject: Re: [PATCH] libsas: move SAM_STAT_CHECK_CONDITION out of switch
From: Dan Williams <dan.j.williams@intel.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Danny Kukawka <dkukawka@suse.de>, Jeff Garzik <jgarzik@redhat.com>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Christoph Hellwig <hch@lst.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 6:49 AM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> Move SAM_STAT_CHECK_CONDITION out of switch to fix:
>
> warning: case value ‘2’ not in enumerated type ‘enum exec_status’
>  [-Wswitch]
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Thanks Danny.  This warning got killed in the following commit that is
pending in -next.

http://git.kernel.org/?p=linux/kernel/git/djbw/isci.git;a=commitdiff;h=9540580ba80e2b3e61041ec935992a7a7d22ff89

--
Dan
