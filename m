Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1DDV3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:29:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42371 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1DDV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:29:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ok28Bc/+WhJG1zH9WJq1Y95fXQxlHCAjD12MvXzs5ybrTwwu5iCf//vsP0tR7beOB+
         VA042bAG5N/43WeFNpGQOMgFFp47DWf6CoOgHo4a6e6Gr2Iu6ohgo5ZWPK1CeVL9XfmA
         9ru9aG1yhYMOlz6Xc1XRL2c54m8nishJvE+Is=
Date: Mon, 4 Apr 2011 14:29:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Cyril Hrubis <metan@ucw.cz>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com
Subject: Re: WARNING: at mm/page_alloc.c
Message-ID: <20110404212906.GA984@core.coreip.homeip.net>
References: <20110404132226.GA14806@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404132226.GA14806@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 03:22:26PM +0200, Cyril Hrubis wrote:
> Hi!
> I'm playing with uinput on zaurus (spitz) I've a pxa-2.6 kernel flashed in the
> uinput is loaded as module. Right after my program called:
> 
> ioctl(fd, UI_DEV_CREATE);
> 
> I've got:
> 
> WARNING: at mm/page_alloc.c:2012 __alloc_pages_nodemask+0148/0x5a8()
> 
> and the ioctl() has failed.
> 
> Anybody has an idea what went wrong?

You do not have enough memory?

Maybe if you could post your program we could see what exactly went
wrong...

Thanks.

-- 
Dmitry
