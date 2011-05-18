Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1ERHG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:06:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60804 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754047Ab1ERHGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:06:25 -0400
Date: Wed, 18 May 2011 00:06:20 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Taylor Hutt <thutt@chromium.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Max98095: Move existing NULL check before pointer
 dereference.
Message-ID: <20110518070619.GA3065@opensource.wolfsonmicro.com>
References: <1305680634-10484-1-git-send-email-thutt@chromium.org>
 <B2150E1E4418E1438554A300EA5040E40DDDA179DA@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40DDDA179DA@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 06:28:04PM -0700, Peter Hsiang wrote:

> Mark, this patch looks good.

I can add your Acked-by?
