Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455Ab2HWU7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:59:08 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54822 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934398Ab2HWU7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:59:03 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [REGRESSION] 3.6-rc2 and 3.6-rc3: TCP/IP network connection hang
Date: Thu, 23 Aug 2012 22:59:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.2-tp520; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201208232235.53312.Martin@lichtvoll.de> <1345755161.5904.1816.camel@edumazet-glaptop> (sfid-20120823_225518_692005_FCE4613B)
In-Reply-To: <1345755161.5904.1816.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208232259.02249.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 23. August 2012 schrieb Eric Dumazet:
> On Thu, 2012-08-23 at 22:35 +0200, Martin Steigerwald wrote:
> > Hi!
> > 
> > Its a bit difficult to describe. With 3.6-rc2 and 3.6-rc3 on an
> > Lenovo ThinkPad T520 from Linus git, I get occasional network hangs:
> > 
> > On for example sending a small mail via SMTP to my Debian Squeeze
> > based server via a ASUS WL-500gP Router with
> > Debian Squeeze and some 2.6.34 kernel KMail hangs.
> > 
> > It just doesn´t complete sending out the mail.
> > 
> > I have seen this once with 3.6-rc2 and now also with 3.6-rc3 that I
> > tried cause it had quite some network fixes.
> > 
> > Notebook: 10.0.0.10 (IP and MAC changed)
> > Gateway:  10.0.0.1 (IP and MAC changed)
> > Server: 194.150.191.11
> > 
> > 
> > Below is a tshark capture of such an occurence.
[…]

> Fix is under way :
> 
> http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=9b04
> f350057863d1fad1ba071e09362a1da3503e

Thanks.

I think I will wait until Linus takes it into his tree and compile a new 
kernel then. Unless you express interest that I test it more quickly. Then 
I may consider doing just that given that the fix applies cleanly to 3.6-
rc3.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
