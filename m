Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0KLKKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:10:16 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:35581 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0KLKKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:10:12 -0500
Date: Fri, 12 Nov 2010 19:10:08 +0900
From: Norbert Preining <preining@logic.at>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Mattia Dongili <malattia@linux.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112101008.GC6726@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org> <20101112035027.GD26742@gamma.logic.tuwien.ac.at> <1289547519.8148.1795.camel@rui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289547519.8148.1795.camel@rui>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang,

On Fr, 12 Nov 2010, Zhang Rui wrote:
> I think the /sys/class/thermal/ and /sys/class/backlight/acpi_video0
> still exists, right?

Yes, right.

> we make ACPI video procfs I/F depend on CONFIG_ACPI_PROCFS, which is
> cleared by default, in 2.6.36, and removed this I/F in 2.6.37-rc1.
> perhaps the backlight control depends on the procfs I/F?

Hmm, I would have expected that the backlight adjustment reacts to the
key sent, as I can use xbacklight by hand, and that is old.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
ADRIGOLE (n.)
The centrepiece of a merry-go-round on which the man with the tickets
stands unnervingly still.
			--- Douglas Adams, The Meaning of Liff
