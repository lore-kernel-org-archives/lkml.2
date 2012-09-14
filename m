Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2INPCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:02:00 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:2787 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612Ab2INPB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:01:58 -0400
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Jim Rees <rees@umich.edu>, "J. Bruce Fields" <bfields@fieldses.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 17:00:47 +0200
In-Reply-To: <alpine.LNX.2.01.1209141624530.18169@frira.zrqbmnf.qr>
References: <20120821212910.GD18637@fieldses.org>
	 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
	 <1347614276.26071.15.camel@thorin>
	 <alpine.LNX.2.01.1209141456290.18169@frira.zrqbmnf.qr>
	 <20120914134637.GA8943@umich.edu>
	 <alpine.LNX.2.01.1209141624530.18169@frira.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347634851.3813.9.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2012-09-14 at 16:25 +0200, Jan Engelhardt wrote:
> On Friday 2012-09-14 15:46, Jim Rees wrote:
> >Jan Engelhardt wrote:
> >  >A pure K&R-C version would use a string:
> >  >#define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
> >  >(if I converted them properly into hexadecimal)
> >  The syntax is \x01\x03\x05...
> >
> >K&R doesn't have the \x escape, only \0 (octal).

We cuold use octal too.

> People recommend K&R only for the introductory reading, not for its 
> actuality.

And I actually used it to show that no gcc-isms are necessary. ANSI-C is
fine too for that case.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

