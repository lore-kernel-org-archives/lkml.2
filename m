Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1LQJ0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 04:26:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab1LQJ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 04:26:36 -0500
Date: Sat, 17 Dec 2011 09:26:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linaro-dev@lists.linaro.org, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        paul.liu@linaro.org, sameo@linux.intel.com
Subject: Re: [Patch] Regulator: Replace kzalloc with devm_kzalloc and if-else
 with a switch-case for da9052-regulator
Message-ID: <20111217092634.GE2833@opensource.wolfsonmicro.com>
References: <1323955793.32031.88.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323955793.32031.88.camel@dhruva>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 06:59:53PM +0530, Ashish Jangam wrote:
> Reported-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Applied, but this really should have been sent as two separate patches
as it's two unrelated changes which don't overlap with each other.
