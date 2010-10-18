Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0JRW1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:27:39 -0400
Received: from fifo99.com ([67.223.236.141]:57476 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604Ab0JRW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:27:37 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <20101018215815.GC23642@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <20101018110207.131b56ee.sfr@canb.auug.org.au>
	 <20101018081520.GA10551@flint.arm.linux.org.uk>
	 <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
	 <20101018182044.GA558@flint.arm.linux.org.uk>
	 <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
	 <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
	 <20101018205847.GB23642@flint.arm.linux.org.uk>
	 <1287437362.5588.57.camel@c-dwalke-linux.qualcomm.com>
	 <20101018215815.GC23642@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 15:27:06 -0700
Message-ID: <1287440826.5588.83.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 22:58 +0100, Russell King wrote:
> On Mon, Oct 18, 2010 at 02:29:22PM -0700, Daniel Walker wrote:
> > That's why we have get_maintainer.pl, it adds in all the CC's
> > automatically ..
> 
> $ git diff-tree -u 861bd81ee62a0d6759144c22909a8a3938951656 | scripts/get_maintainer.pl |wc 
>     209     624    8021
> 
> 209 recipients / 8K of To:/CC: is reasonable?


The answer is not "The tool doesn't work like I want, so screw it." If
the tool doesn't work like we want, then we need to fix the tool not
just walk away. Not to mention that the people involved in making these
patches should still be CC'ing people even if this tool is just helping
them out instead of actually doing it for them.

What it's showing you is anyone that's ever modified those files.. You
just need the people who maintain the files.

how about this,

git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl | wc
     58     163    2169

That's the patch we're actually discussing too. It's about one CC per
file modified.

Daniel

