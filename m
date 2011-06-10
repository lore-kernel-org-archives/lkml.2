Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab1FJSH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:07:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40344 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757736Ab1FJSH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:07:57 -0400
Date: Fri, 10 Jun 2011 19:07:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
Message-ID: <20110610180755.GR26436@opensource.wolfsonmicro.com>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <20110610172734.GI26441@sirena.org.uk>
 <BANLkTimN0-a++2Nd13rHGSwkVPDxU8GBhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimN0-a++2Nd13rHGSwkVPDxU8GBhQ@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:44:00PM -0400, Mike Frysinger wrote:
> On Fri, Jun 10, 2011 at 13:27, Mark Brown wrote:

> > Also someone should remonstrate with the hardware designers.

> if there's things we can take back, i can forward them along.  the
> last conversation i had with them sounded like they have no problem
> accepting feedback.

I was referring to the fact that different registers have different
sizes which does rather complicate the code.
