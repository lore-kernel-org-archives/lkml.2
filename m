Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0GAQ0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:26:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0GAQ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:26:13 -0400
Date: Thu, 1 Jul 2010 12:26:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, gnb@melbourne.sgi.com
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Message-ID: <20100701162601.GC2829@redhat.com>
References: <201007011744.19564.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007011744.19564.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:44:19PM +0200, Thomas Renninger wrote:
> 
> Hi,
> 
> Doing:
> echo "file ec.c +p" >/sys/kernel/debug/dynamic_debug/control
> 
> I got x
> RIP: 0010:[<ffffffff81251267>]  [<ffffffff81251267>] 
> ddebug_change+0x87/0x240
> 
> More output is in the attachment.
> 
> Thanks for any hints,
> 
>       Thomas

Hi Thomas,

I just tried the same command on 2.6.35-rc3, and it worked fine. I
noticed that the kernel your running is: "2.6.35-rc3-0.0.10.4cae135-default",
so perhaps there are some other changes there causing this problem? Can
you re-produce the bug on a purely upstream kernel?

thanks,

-Jason

