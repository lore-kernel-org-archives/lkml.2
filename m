Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab0KPFQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:16:50 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57193 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0KPFQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:16:49 -0500
Date: Tue, 16 Nov 2010 14:16:42 +0900
From: Norbert Preining <preining@logic.at>
To: Mattia Dongili <malattia@linux.it>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101116051642.GA24410@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org> <20101112035027.GD26742@gamma.logic.tuwien.ac.at> <20101112035732.GB7574@srcf.ucam.org> <20101112042243.GE2852@kamineko.org> <20101112043922.GA19889@gamma.logic.tuwien.ac.at> <20101112121742.GA17690@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112121742.GA17690@kamineko.org>
X-IMAPbase: 1289640783 1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 12 Nov 2010, Mattia Dongili wrote:
> You will need an updated input-kbd to set the scancode map.

Ouch.

> > Does that mean that 2.6.37rc is too new for the user space?
> 
> Maybe. Anyway if evtest reacts positively to key presses then it's a
> userspace issue and not the driver's.

What is strange that there *WAS* a change in the kernel that triggered
that. Old kernels still work fine. I just tried 2.6.36 and it was working.

I always thought that kernel changes should not break user space
(well, without good reason).

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
Does it worry you that you don't talk any kind of sense?
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
