Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030552Ab2AFTBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:01:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33549 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758970Ab2AFTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:01:39 -0500
Date: Fri, 6 Jan 2012 11:01:26 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lrg@ti.com, patches@linaro.org,
        eric.miao@linaro.org
Subject: Re: [PATCH v2 1/1] regulator: set constraints.apply_uV to 0 in
 of_get_fixed_voltage_config
Message-ID: <20120106190124.GE2893@opensource.wolfsonmicro.com>
References: <1325225213-29655-1-git-send-email-richard.zhao@linaro.org>
 <1325646449-21916-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325646449-21916-1-git-send-email-richard.zhao@linaro.org>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 11:07:29AM +0800, Richard Zhao wrote:
> Fix fixed regulator using DT failed to call regulator_register.
> 
> of_get_regulator_init_data set apply_uV to 1, but fixed regulator
> doesn't need it. Set it back to 0.

Applied, thanks.
