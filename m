Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0KKXuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:50:05 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47973 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab0KKXuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:50:03 -0500
Date: Fri, 12 Nov 2010 08:50:00 +0900
From: Norbert Preining <preining@logic.at>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110035833.GB3029@kamineko.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 10 Nov 2010, Mattia Dongili wrote:
> It's ages sony_laptop doesn't change, it may be some other change in the
> acpi layer that causes this.

Seems so that the sys files have changed to new locations:
/sys/devices/virtual/backlight/acpi_video0/brightness

(mind the additional "virtual")
as well as thermal zone etc etc.

Could that explain the problem?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
CAARNDUNCAN (n.)
The high-pitched and insistent cry of the young female human urging
one of its peer group to do something dangerous on a cliff-edge or
piece of toxic waste ground.
			--- Douglas Adams, The Meaning of Liff
