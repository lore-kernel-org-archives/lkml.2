Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1CDGVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:21:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59686 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1CDGVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=srAvbxixf27tWTh2iRUkzS7OyQPgRvZ4EjiHrF3dfTI3XXcRHsAgZp2FpPm1sSR/Zr
         O6AQVEIc/v3ApwK3uVXV4G9qw8D06RiMlvTTIgq02HsbPiduOesyI25X7RLavFvxikvr
         915YdCIT6f+FPghQn1csWrr1XIyxyt5yVteTg=
Date: Fri, 4 Mar 2011 07:21:20 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: some patches for the ptp framework
Message-ID: <20110304062120.GB3824@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299173174-348-1-git-send-email-torbenh@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 06:26:11PM +0100, Torben Hohn wrote:
> patches 1 and 3 apply on top of tip:core/timer
> 
> patch 2 also requires Richards ptp v12 1/4 for the ptp class.
> modulo a small conflict in drivers/ptp/Makefile and Kconfig.
> because i had added his ixp driver, which the software clock is based on.
> 
> Richards Patchset didnt apply to tip:core/timer as is.
> which branch is it based on ?

I can apply them to

   db1c1cce4a653dcbe6949c72ae7b9f42cab1b929

near the head of timers/core in

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

I guess the newer CLOCK_BOOTTIME commits cause a conflict. I will
rebase once again to fix that.

Thanks,
Richard


