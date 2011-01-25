Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1AYPEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:04:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38799 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1AYPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:04:32 -0500
Date: Tue, 25 Jan 2011 15:04:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: halli manjunatha <manjunatha_halli@ti.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] TI WL 128x FM V4L2 driver
Message-ID: <20110125150430.GF13051@sirena.org.uk>
References: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinAYrGV1k357Bn8trtxafZDoYozG7LDcm3KNBSt@mail.gmail.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:18:18AM +0530, halli manjunatha wrote:

> This is TI WL128x FM V4L2 driver and it introduces ?wl128x? folder
> under the ?drivers/media/radio?. This driver enables support for FM RX
> and TX for Texas Instrument's WL128x (also compatible with WL127x)

How does this all interact with the existing wl1273 driver that's now in
mainline?
