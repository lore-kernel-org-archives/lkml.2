Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0LAIJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:09:00 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:49604 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab0LAII7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:08:59 -0500
Date: Wed, 1 Dec 2010 09:08:50 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
Message-ID: <20101201080850.GK10354@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
 <1291172324.14274.33.camel@nayuki>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291172324.14274.33.camel@nayuki>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Muni-Spam-TestIP: 94.112.253.31
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 01 Dec 2010 09:08:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 09:58:44PM -0500, Calvin Walton wrote:
> The mute button on this series of Thinkpads is a little weird (I have an
> R61i, which is the same iirc) - the behaviour of the button depends on
> the ACPI firmware. With no operating system running, it behaves as a
> persistent hardware mute. Windows apparently uses a proprietary driver
> to control the volume - part of this functionality has been added to the
> Linux thinkpad_acpi driver, but it's not fully enabled yet.

Behaviour in 2.6.36 kernel is OK as expected. Something broken it in
2.6.37-rc1.

> Search your dmesg for lines containing '_OSI(Linux)' - it should say
> that a BIOS query was honoured. Make sure you do not have 'acpi_osi="!
> Linux"' on your kernel command line.

[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
[    0.000000] ACPI: Added _OSI(Linux)

looks good.

-- 
Luká¹ Hejtmánek
