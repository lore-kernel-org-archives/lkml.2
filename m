Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2JKHSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:18:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45920 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab2JKHSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:18:08 -0400
Date: Thu, 11 Oct 2012 16:18:00 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Minor improvements
Message-ID: <20121011071759.GC11726@opensource.wolfsonmicro.com>
References: <1349870093.13275.16.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349870093.13275.16.camel@matrix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 05:24:53PM +0530, Ashish Chavan wrote:
> This patch includes two minor improvements for da9055 codec driver
> 
> (1) Adding support for DSP mode of AIF
> (2) Muting Mic PGAs during ALC calibration process

Send one patch per change.  I suspect the second change is a bug fix
rather than an new feature so should go in separately anyway...
