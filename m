Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2INNrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:47:03 -0400
Received: from mout.perfora.net ([74.208.4.195]:57120 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab2INNrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:47:00 -0400
Date: Fri, 14 Sep 2012 09:46:37 -0400
From: Jim Rees <rees@umich.edu>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120914134637.GA8943@umich.edu>
References: <20120821212910.GD18637@fieldses.org>
 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
 <1347614276.26071.15.camel@thorin>
 <alpine.LNX.2.01.1209141456290.18169@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209141456290.18169@frira.zrqbmnf.qr>
X-Provags-ID: V02:K0:Io3K1QCdXdwO9XluXiqiOVTAqLGYsxUmcNvsrQwXS1z
 E7JcHu3yoRRjFfTDlvMdWWCKeEtX3ueHCnEgmokY3g+56wcGcf
 2zHfiewJfwrGhSwI+u0l96JkC10ygtCZCX269dfMu0uQhaoGmu
 MBmRM3px4b9tEHTjbVDocR1hiLnBm68KpkEFVklCu3XxxViUhC
 dUx7Wrwb7jZPIbC4Ew5/xZrzSCNElT6FXpNTTmLnhrE4M2XND8
 o5E4/IYT5ouFcCafpyjHNjJBbrIoiMDgW80JW1IyDhivUMkh+X
 PJ5/VHNi2GtsXItU7ooQNqax+JPurFxyRV82/3k9xGfaeh6zQ=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

  >A pure K&R-C version would use a string:
  >#define base10len(i) "\0x1\0x3\0x5\0x8\0x0A\0x0D\0x0F\0x11\0x14"[sizeof(i)]
  >(if I converted them properly into hexadecimal)
  The syntax is \x01\x03\x05...

K&R doesn't have the \x escape, only \0 (octal).
