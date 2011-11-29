Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1K2MC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:02:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36526 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1K2MC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:02:27 -0500
Date: Tue, 29 Nov 2011 12:02:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: drivers@analog.com, alsa-devel@alsa-project.org,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v2 1/7] firmware: Sigma: Prevent out of
 bounds memory access
Message-ID: <20111129120224.GL2851@opensource.wolfsonmicro.com>
References: <1322469860-8210-1-git-send-email-lars@metafoo.de>
 <20111129101247.GA2851@opensource.wolfsonmicro.com>
 <4ED4B17C.3090905@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED4B17C.3090905@metafoo.de>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 11:18:36AM +0100, Lars-Peter Clausen wrote:

> He acked some patches this morning. As far as I can see all of the patches
> do have his acked-by now.

Oh, so he has - applied now.
