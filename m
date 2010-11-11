Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0KKVR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:17:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38290 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755513Ab0KKVR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:17:56 -0500
Date: Thu, 11 Nov 2010 21:18:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Add MAX98089 CODEC driver
Message-ID: <20101111211801.GA3399@opensource.wolfsonmicro.com>
References: <4CDC5033.50302@maxim-ic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDC5033.50302@maxim-ic.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 02:21:07PM -0600, Jesse Marroquin wrote:
> This patch adds the initial driver for the MAX98089 CODEC.

I've not read this properly yet but on a first quick scan through this
bears a more than passing resemblance to the MAX98088 driver - are there
sufficient incompatibilities between the chips to warrant having a
separate driver?  http://datasheets.maxim-ic.com/en/ds/MAX98088.pdf
would suggest not...  

Keeping a single driver means less code to maintain, which is generally
a win.  Variations between the parts can be accommodated by registering
different controls and so on based on the I2C device ID that the system
registers.
