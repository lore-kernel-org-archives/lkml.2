Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1LNNmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 08:42:15 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47398 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab1LNNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:42:14 -0500
Date: Wed, 14 Dec 2011 17:42:09 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linaro-dev@lists.linaro.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        paul.liu@linaro.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Subject: Re: [PATCH 05/06] Power: DA9052 Battery module V6
Message-ID: <20111214134209.GA21965@oksana.dev.rtsoft.ru>
References: <1323865676.32031.24.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323865676.32031.24.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:57:56PM +0530, Ashish Jangam wrote:
> Driver for DA9052 battery charger. This driver depends on DA9052 MFD core dirver
> for definitions and methods.
> 
> This patch is functionally tested on Samsung SMDKV6410.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

I presume this depends on other patches, so I'm fine if this goes via
non-battery tree,

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>


If you want me to merge it into battery git tree, I can do it
as well.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
