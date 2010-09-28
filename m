Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0I1O3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:29:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753915Ab0I1O3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:29:21 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18w4gdqNa0wts5c7TdWcXFFzQrDAWF0O8HQUcJHW2
	OhRg631t42cyGf
Date: Tue, 28 Sep 2010 16:29:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Raymond Liu <raymondliu3linux@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: HDMI open source to handle audio/video/CEC in one driver
In-Reply-To: <AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1009281624100.11083@axis700.grange>
References: <AANLkTimMH604FW_NZehY68w8B_cV_Lhe-ZwZq0cAYUfd@mail.gmail.com>
 <AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Sep 2010, Raymond Liu wrote:

> Hi,
> 
> My company is working on the Linux HDMI open source driver for our
> chipsets (with audio/video/CEC controls).  Is there any similar
> project ongoing for this kind of driver in Linux community?  Who
> should I contact with for this?

I think, it depends on what kind of hardware it is, resp, what kind of a 
driver you'd like to have. Best fit for HDMA, IMHO, is a KMS driver. If, 
however, that's too much for you and you only want a framebuffer driver, 
you might want to have a look, how HDMI support has been recently added to 
the sh_mobile_lcdcfb.c driver - both video and audio. Try to begin here 
http://search.gmane.org/?query=hdmi&group=gmane.linux.ports.sh.devel and 
look for patches from Morimoto-san and myself. But HDMI with framebuffer 
is not a very elegant combination, so, if you can, try KMS.

Good luck
Guennadi

> 
> Thanks,
> Raymond Liu
> 
> P.S. I wish to be personally CC'ed the answers/comments posted to the
> list in response to my posting.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
