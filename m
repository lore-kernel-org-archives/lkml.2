Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1FXMAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:00:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44086 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660Ab1FXMAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:00:43 -0400
Date: Fri, 24 Jun 2011 13:00:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [alsa-devel] [PATCH 1/3] ASoC: Add ADAV80x codec driver
Message-ID: <20110624120040.GD9483@opensource.wolfsonmicro.com>
References: <1308808818-26775-1-git-send-email-lars@metafoo.de>
 <4E0332C5.7010608@ti.com>
 <4E03DDEC.9060608@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E03DDEC.9060608@metafoo.de>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 02:44:28AM +0200, Lars-Peter Clausen wrote:
> On 06/23/2011 02:34 PM, Liam Girdwood wrote:

> > It's usually better disable things like sysclk output in your machine driver as others may depend on it for probing.

> What is the proper API to do this? set_sysclk with dir = SND_SOC_CLOCK_OUT and
> freq = 0?

Something like that, yes.
