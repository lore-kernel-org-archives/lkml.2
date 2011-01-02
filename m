Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1ABNz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 08:55:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49498 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753813Ab1ABNz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 08:55:56 -0500
Date: Sun, 2 Jan 2011 13:56:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 3/4] regulator MAX8998/LP3974: Support DVS-GPIO.
Message-ID: <20110102135612.GH4935@opensource.wolfsonmicro.com>
References: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
 <1293094419-24221-4-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293094419-24221-4-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:53:38PM +0900, MyungJoo Ham wrote:
> The previous driver did not support BUCK1-DVS3, BUCK1-DVS4, and
> BUCK2-DVS2 modes. This patch adds such modes and an option to block
> setting buck1/2 voltages out of the preset values.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
