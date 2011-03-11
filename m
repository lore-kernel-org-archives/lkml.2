Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1CKMAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:00:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41196 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751952Ab1CKMAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:00:12 -0500
Date: Fri, 11 Mar 2011 12:00:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 2/4] MAX8997/8966 PMIC Regulator Driver Initial
 Release
Message-ID: <20110311120010.GC1760@opensource.wolfsonmicro.com>
References: <1299810886-19684-1-git-send-email-myungjoo.ham@samsung.com>
 <1299810886-19684-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299810886-19684-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:34:44AM +0900, MyungJoo Ham wrote:
> This patch supports PMIC/Regulator part of MAX8997/MAX8966 MFD.
> In this initial release, selecting voltages or current-limit
> and switching on/off the regulators are supported.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though I do still think that voltage range information might make the
side effect handling more useful.
