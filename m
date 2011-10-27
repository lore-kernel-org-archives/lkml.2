Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1J0J6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:58:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33056 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab1J0J6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:58:49 -0400
Date: Thu, 27 Oct 2011 11:58:47 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320aic3x: Use snd_soc_update_bits for
 read-modify-write
Message-ID: <20111027095846.GA22369@opensource.wolfsonmicro.com>
References: <1319638397.6637.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319638397.6637.2.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 10:13:17PM +0800, Axel Lin wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write

Applied, thanks.
