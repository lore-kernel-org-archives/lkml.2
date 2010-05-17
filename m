Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0EQCve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:51:34 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:32802 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0EQCvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NmBNQ3/mQ+CfLhTzdsEmGd92LQXy6RVPm2eC2SeqrssJ7jDi66iAZDpP4JT87p5ZDG
         tg9pDBce9X/Vn/QULPCwxwR/hzjQRIrxvpCI74tBVC8mPYFqMqWrjncJ04nr6gkNIQkl
         YHyAiTAiDq9VLQAduChuLTfdoGtZGivSC+7k8=
Date: Mon, 17 May 2010 04:51:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/7] cris: push down BKL into some device drivers
Message-ID: <20100517025135.GI22299@nowhere>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <1272378265-10909-4-git-send-email-arnd@arndb.de> <20100430075320.GZ29275@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430075320.GZ29275@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 09:53:21AM +0200, Jesper Nilsson wrote:
> On Tue, Apr 27, 2010 at 04:24:21PM +0200, Arnd Bergmann wrote:
> > A number of cris specific device drivers still use the
> > locked ->ioctl operation. Convert them to unlocked_ioctl
> > with explicit lock_kernel calls.
> 
> Looks good, I've added this to the cris tree.


Ok, zapped it from mine then.

Thanks.



> 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> /^JN - Jesper Nilsson
> -- 
>                Jesper Nilsson -- jesper.nilsson@axis.com

