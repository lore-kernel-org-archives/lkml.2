Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2INOZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:25:20 -0400
Received: from ares07.inai.de ([5.9.24.206]:51831 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2INOZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:25:18 -0400
Date: Fri, 14 Sep 2012 16:25:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Jim Rees <rees@umich.edu>
cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
In-Reply-To: <20120914134637.GA8943@umich.edu>
Message-ID: <alpine.LNX.2.01.1209141624530.18169@frira.zrqbmnf.qr>
References: <20120821212910.GD18637@fieldses.org> <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr> <1347614276.26071.15.camel@thorin> <alpine.LNX.2.01.1209141456290.18169@frira.zrqbmnf.qr> <20120914134637.GA8943@umich.edu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2012-09-14 15:46, Jim Rees wrote:

>Jan Engelhardt wrote:
>
>  >A pure K&R-C version would use a string:
>  >#define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
>  >(if I converted them properly into hexadecimal)
>  The syntax is \x01\x03\x05...
>
>K&R doesn't have the \x escape, only \0 (octal).

People recommend K&R only for the introductory reading, not for its 
actuality.
