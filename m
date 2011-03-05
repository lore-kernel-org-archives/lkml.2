Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1CELbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 06:31:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49240 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752690Ab1CELbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 06:31:22 -0500
Date: Sat, 5 Mar 2011 11:31:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 1/2] MAX8997/8966 MFD Driver Initial Release
 (PMIC+RTC+MUIC+Haptic+...)
Message-ID: <20110305113143.GB30187@opensource.wolfsonmicro.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
 <1299221427-4726-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299221427-4726-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 03:50:26PM +0900, MyungJoo Ham wrote:
> MAX8997/MAX8966 chip is a multi-function device with I2C bussses. The
> chip includes PMIC, RTC, Fuel Gauge, MUIC, Haptic, Flash control, and
> Battery (charging) control.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
