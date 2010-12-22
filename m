Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0LVNgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:36:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43682 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751876Ab0LVNgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:36:00 -0500
Date: Wed, 22 Dec 2010 13:36:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 6/6] MFD MAX8998/LP3974: Support DVS-GPIO.
Message-ID: <20101222133612.GG26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
 <1292998991-26968-7-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292998991-26968-7-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:23:11PM +0900, MyungJoo Ham wrote:
> The previous driver did not support BUCK1-DVS3, BUCK1-DVS4, and
> BUCK2-DVS2 modes. This patch adds such modes and an option to block
> setting buck1/2 voltages out of the preset values.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
