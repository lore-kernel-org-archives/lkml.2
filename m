Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1CGMZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 07:25:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38242 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751004Ab1CGMZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 07:25:22 -0500
Date: Mon, 7 Mar 2011 12:25:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jassi Brar <jassi.brar@samsung.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario management
 code.
Message-ID: <20110307122520.GI13471@opensource.wolfsonmicro.com>
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
 <1299495878.3377.17.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299495878.3377.17.camel@odin>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:04:38AM +0000, Liam Girdwood wrote:

> Just had a quick look. All 

> Acked-by: Liam Girdwood <lrg@ti.com>

Applied 1-6 - I'll wait for Kukjin to check patch 7 just in case he
wants it to go via his tree, there's no compile time dependency.
