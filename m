Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0LBSZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:25:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:40142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab0LBSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:25:35 -0500
Date: Thu, 2 Dec 2010 18:25:21 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: Microcai <microcai@fedoraproject.org>, Vojtech Pavlik <vojtech@suse.cz>,
        linuxconsole@vger.kernel.org,
        Linux console project <linuxconsole-dev@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mattia Jona-Lasinio <mattia.jona@gmail.com>,
        lcd-linux-users@lists.sourceforge.net
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
In-Reply-To: <20101202135923.GA11944@const.bordeaux.inria.fr>
Message-ID: <alpine.LFD.2.00.1012021821030.19542@casper.infradead.org>
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr> <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com> <20101128081528.GA20705@suse.cz> <1290932981.710.2.camel@cai.gentoo>
 <alpine.LFD.2.00.1012020137320.28091@casper.infradead.org> <20101202135923.GA11944@const.bordeaux.inria.fr>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-81951701-1291314073=:19542"
Content-ID: <alpine.LFD.2.00.1012021821300.19542@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-81951701-1291314073=:19542
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1012021821301.19542@casper.infradead.org>



On Thu, 2 Dec 2010, Samuel Thibault wrote:

> James Simmons, le Thu 02 Dec 2010 13:50:28 +0000, a écrit :
> > 	This is nice and neat for vgacon but it doesn't flow so nicely with 
> > graphical consoles or text LCDs. What I like to see is the attribute 
> > buffer be split from the vc_screenbuf. The bonus is in embbeded systems we 
> > could arrange the code so we could have a light weight printk VT without 
> > the extra junk of the VC. Do we really need a attribute buffer for printk?  
> > I believe that would be the first step in the right direction.
> 
> That's exactly what I suggested privately to Microcai. Increasing the
> number of supported glyphs should then becomes way simpler, and
> double-width not so far.

The challenge would be the scrolling code. I cc'ed the LCD group to voice 
there needs as well.

--1985284609-81951701-1291314073=:19542--
