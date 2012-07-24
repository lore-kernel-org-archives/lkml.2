Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2GXWqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:46:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab2GXWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:46:52 -0400
Date: Tue, 24 Jul 2012 23:46:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Help request - ASoC recursion issue
Message-ID: <20120724224649.GE1767@opensource.wolfsonmicro.com>
References: <500D5A1F.9000808@linaro.org> <500D649B.80704@linaro.org> <500D6602.6070809@linaro.org> <20120723181249.GF3421@mudshark.cambridge.arm.com> <500E4E2C.3060804@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E4E2C.3060804@linaro.org>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 08:26:36AM +0100, Lee Jones wrote:

> Yes, I am inclined to agree with you. I just thought it was  
> uncharacteristic of a memory corruption error, as can reliably reproduce  
> the bootlog above. What's even more strange is that the issue only  
> arises on one of my two _identical_ development boards.

It's not that unusual depending on where the cause is - for example,
copying an initialised struct to the wrong place, and things like the
DAPM graph which are big and pointer driven are often affected.
