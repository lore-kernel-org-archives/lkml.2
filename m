Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2EHWQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:16:24 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:53422 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231Ab2EHWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:16:22 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Woodruff\, Richard" <r-woodruff2@ti.com>
Cc: "AnilKumar\, Chimata" <anilkumar@ti.com>, "J\, KEERTHY" <j-keerthy@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Pihet-XID\, Jean" <j-pihet@ti.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [linux-pm] [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Organization: Texas Instruments, Inc.
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
	<20120426191159.GA9415@sirena.org.uk>
	<CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
	<20120427175657.GP18260@opensource.wolfsonmicro.com>
	<87397o3n4y.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B1A67@DBDE01.ent.ti.com>
	<87mx5jy2li.fsf@ti.com>
	<331ABD5ECB02734CA317220B2BBEABC13E9B6681@DBDE01.ent.ti.com>
	<EF62F09C0797D947AD4180A1043C0DF73C40BCE1@DLEE10.ent.ti.com>
Date: Tue, 08 May 2012 15:16:36 -0700
In-Reply-To: <EF62F09C0797D947AD4180A1043C0DF73C40BCE1@DLEE10.ent.ti.com>
	(Richard Woodruff's message of "Tue, 8 May 2012 20:38:35 +0000")
Message-ID: <87lil2jp2z.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Woodruff, Richard" <r-woodruff2@ti.com> writes:

>> > >> The only thing the higher-level layers might potentially need to
>> > >> do is to enable/disable AVS around transitions (e.g. when
>> > >> changing OPP, > > >> AVS is disabled before changing OPP and
>> > >> only re-enabled when the new > >> >> nominal voltage has been
>> > >> acheived.)
>
> Getting clean baseline in place is huge step but actual production
> interfaces will need to comprehend some OPP to AVS dependencies beyond
> on/off.

A basic OMAP AVS driver has been in mainline for a long time, yet we
have not seen support submitted for all of these features.

When folks are motivated to propose such changes upstream, we will be
happy to discuss them and add support for them to the AVS driver.

Until then, the primary purpose of this series is to do some minimal
cleanup of an *existing* driver so it can be moved into drivers/*.  New
features can be added there as easily as they could've been added when
it was a driver under arch/arm.

Kevin

