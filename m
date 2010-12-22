Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0LVNWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:22:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49306 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753342Ab0LVNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:22:24 -0500
Date: Wed, 22 Dec 2010 13:22:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 1/6] MFD MAX8998/LP3974: Support Hibernation
Message-ID: <20101222132235.GA26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
 <1292998991-26968-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292998991-26968-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:23:06PM +0900, MyungJoo Ham wrote:
> With runtime-pm ops support, this patch enables to save and restore
> register values for hibernation.

There's no actual runtime PM support in this patch, but this looks like
it's just an error in the changelog?
