Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0KLEjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 23:39:31 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:46468 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab0KLEja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 23:39:30 -0500
Date: Fri, 12 Nov 2010 13:39:22 +0900
From: Norbert Preining <preining@logic.at>
To: Mattia Dongili <malattia@linux.it>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112043922.GA19889@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org> <20101112035027.GD26742@gamma.logic.tuwien.ac.at> <20101112035732.GB7574@srcf.ucam.org> <20101112042243.GE2852@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112042243.GE2852@kamineko.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 12 Nov 2010, Mattia Dongili wrote:
> backlight (actually Fn+F[56]) is one of those keys the needs remapping
> these days, i.e. if xev doesn't get any event in X then you may need

It doesn't.

> $ diff -u <(sudo input-kbd 5) vaio-kbd
> /dev/input/event5
>    bustype : BUS_ISA
>    vendor  : 0x104d
>    product : 0x0
>    version : 0
>    name    : "Sony Vaio Keys"
>    bits ev : EV_SYN EV_KEY EV_MSC

Ahhhhh
	root$ input-kbd 8
	/dev/input/event8
	protocol version mismatch (expected 65536, got 65537)
and the same for all event devices??

I have input-kbd from xserver-xorg-input-kbd in Debian/sid, which is
at 1:1.4.0-2 version.

Does that mean that 2.6.37rc is too new for the user space?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
MATCHING GREEN (adj.)
(Of neckties.) Any colour which Nigel Rees rejects as unsuitable for
his trousers or jacket.
			--- Douglas Adams, The Meaning of Liff
