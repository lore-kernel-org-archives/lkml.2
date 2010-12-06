Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0LFMzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:55:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59250 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752399Ab0LFMzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:55:50 -0500
Date: Mon, 6 Dec 2010 12:55:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Hold client_mutex while calling
 snd_soc_instantiate_cards()
Message-ID: <20101206125544.GD1924@rakim.wolfsonmicro.main>
References: <1291625283.11404.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291625283.11404.2.camel@mola>
X-Cookie: Dr. Jekyll had something to Hyde.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 04:48:03PM +0800, Axel Lin wrote:
> As the comments of snd_soc_instantiate_cards() said,
> snd_soc_instantiate_cards() must be called with client_mutex.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
