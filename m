Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0GNT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:26:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33165 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752530Ab0GNT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:26:16 -0400
Date: Wed, 14 Jul 2010 20:26:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, Neil Jones <neil.jones@imgtec.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] wm8727: add a missing return in wm8727_platform_probe
Message-ID: <20100714192612.GA7532@rakim.wolfsonmicro.main>
References: <1279105051.2290.5.camel@phoenix>
 <1279119597.3080.120.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279119597.3080.120.camel@odin>
X-Cookie: No line available at 300 baud.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 03:59:57PM +0100, Liam Girdwood wrote:
> On Wed, 2010-07-14 at 18:57 +0800, Axel Lin wrote:
> > otherwise the error path will always be executed.

> Both

> Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

...and applied, thanks.
