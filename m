Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2DQQOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:14:10 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:43972 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755863Ab2DQQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:14:08 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/4] Add Wolfson Microelectronics WM8776 codec ALSA driver
Date: Tue, 17 Apr 2012 18:13:40 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org> <1334611118-10301-4-git-send-email-linux@rainbow-software.org> <20120417150234.GB22575@sirena.org.uk>
In-Reply-To: <20120417150234.GB22575@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204171813.44044.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012 17:02:34 Mark Brown wrote:
> On Mon, Apr 16, 2012 at 11:18:37PM +0200, Ondrej Zary wrote:
> > Needed by Philips PSC724 subdriver. The code does not contain any
> > card-specific bits so it can be used by any other ALSA driver.
>
> Same comments as the previous patch, this should be using ASoC.  In this
> case the device has in fact been supported in mainline since 2.6.32...

Yes, the driver is there - but I dont's see any way to use it. ASoC was not 
designed to be used with sound cards and nobody has ever used any ASoC driver 
in a sound card driver. I don't feel like breaking a working driver (with 16 
subdrivers for many more card types).

-- 
Ondrej Zary
