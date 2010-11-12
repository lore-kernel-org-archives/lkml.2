Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0KLEPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 23:15:00 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:56288 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0KLEO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 23:14:58 -0500
Date: Fri, 12 Nov 2010 13:14:55 +0900
From: Norbert Preining <preining@logic.at>
To: Matthew Garrett <mjg@redhat.com>
Cc: Mattia Dongili <malattia@linux.it>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112041455.GF26742@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org> <20101112035027.GD26742@gamma.logic.tuwien.ac.at> <20101112035732.GB7574@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112035732.GB7574@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 12 Nov 2010, Matthew Garrett wrote:
> Then yes, that's probably related to sony-laptop. If you run evtest 
> against the /dev/input/event device that corresponds to sony-laptop, 
> what events do you get when you hit the brightness keys?

(after playing around to find the right /dev/input/event?)

Event: time 1289535264.900005, type 1 (Key), code 470 (?), value 1
Event: time 1289535264.900013, type 4 (Misc), code 4 (ScanCode), value 10
Event: time 1289535264.900016, -------------- Report Sync ------------
Event: time 1289535264.914232, type 1 (Key), code 470 (?), value 0
Event: time 1289535264.914239, -------------- Report Sync ------------
Event: time 1289535265.415803, type 1 (Key), code 471 (?), value 1
Event: time 1289535265.415827, type 4 (Misc), code 4 (ScanCode), value 11
Event: time 1289535265.415835, -------------- Report Sync ------------
Event: time 1289535265.430214, type 1 (Key), code 471 (?), value 0
Event: time 1289535265.430217, -------------- Report Sync ------------

(pressing brightness down and up, each once)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`Time is an illusion. Lunchtime doubly so.'
you should send that in to the
"Reader's Digest". They've got a page for people like you.'
                 --- Ford convincing Arthur to drink three pints in ten
                 --- minutes at lunchtime.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
