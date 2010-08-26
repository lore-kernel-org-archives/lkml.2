Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0HZUvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 16:51:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33779 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752207Ab0HZUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 16:51:35 -0400
Date: Thu, 26 Aug 2010 22:07:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped
 controllers
Message-ID: <20100826220747.6da28e97@lxorguk.ukuu.org.uk>
In-Reply-To: <216397.86259.qm@web180306.mail.gq1.yahoo.com>
References: <20100826174822.75094415@lxorguk.ukuu.org.uk>
	<216397.86259.qm@web180306.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> If there are "zillions" that suggests the HW
> engineers have version/naming issues just like
> certain software engineers.  Only goes to show
> how close Verilog and VHDL are to software! :)

Verilog ? Its far far more primitive than that. You'll find exactly that
arrangement in prehistoric 8bit micro support chips - eg the 6522. In
fact the only reason I can see for not using it on primitive 8bit micro
devices is that they *already* had more features.

> are not reusing a named module; they are at best
> just copying/pasting some Verilog/VHDL and adding
> ASIC/SoC/.../FPGA-specific hacks.  (Which calls into
> question just how much assurance there can be that
> one driver will work reliably for all instances...

No they are implementing trivial common sense logic. It's a bit like
complaining we have multiple drivers that use addition.

I think you need a reality check. Its a VLSI undergraduate project level
device, or was back when they taught undergraduates a sampling of chip
design by drawing the transistors. This is "my first logic design" stuff.

Alan
