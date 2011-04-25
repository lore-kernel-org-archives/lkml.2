Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab1DYTlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:41:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37617 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab1DYTlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uB/dsl3Ld1XhlCd1Apfz68v+NnZu3SBLbqY0SYvex8MnvjAd77I/1JQJP8PB2Ri8cO
         4es8DnQqF6MfNJiYOTpzdmZtQhjJgwyrKEUYQ4xji14eSCiPBg1Gz7AOMizEcxqxNucV
         iv4AvcrdP73/FatPRvOEQrZhM4L5c4gOi+ycw=
Date: Mon, 25 Apr 2011 21:41:49 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: =?utf-8?B?SMOldmFyIE7DuHZpaw==?= <havar.novik@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gma500
Message-ID: <20110425194149.GA2145@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <BANLkTi=78E5Rr9CogVEDT4baQPbz8Hq19g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=78E5Rr9CogVEDT4baQPbz8Hq19g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 03:59:36PM +0200, Håvar Nøvik wrote:
> Hi, I see that you are the owner of the gma500 repo on kernel.org. I'm not
> familiar with the kernel development, so I may be all wrong here. But it
> looked like Linus merged your repo into the mainline kernel for .39? Is this
> correct? What condition is the gm500 driver in at this time? Is it usable?

Hi,

Well, Alan Cox has been working on the gma500 driver for a month or so. 
I personally got an sony vaio p21z/r which contains the gma500 chipset, so I
created an repository for personal use. Im maintainer for a couple of platforms so
put it up on kernel.org for any other gma500 users wanting to test it out, since it wont be merged in mainline (linus tree) until v2.6.40. My repository is based on v2.6.39-rc1.

The current status is:
Framebuffer works fine
2D acceleration is working to some extent (2/3 accelerations active)
3D acceleration is only software so far (=slow)
VGA output (external monitor) works but is locked to same resolution as onboard monitor. If the external monitor cant handle the onboard resolution (like mine that got 1600x768) it will move down to the lowest common resolution (usually 1024x768).

So now to your question, is it usable. Yes very much so.
Its stable and works well. Updates are coming every week and it keeps getting better.
Unless you need 3D acceleration I would recommend it to anyone using gma500.

I will keep merging alans work into that branch (v2.6.39-rc1-gma500) until the
stable 2.6.39 is released, then I will create v2.6.39-gma500 and continue
merging patches there. 

Until its fully supported in mainline I will keep my repository up.

Best wishes
Kristoffer

ps. CC:ed kernel mainlinglist since Ive been getting this question alot lately.
 
> ----
> Regards Håvar Nøvik
