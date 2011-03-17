Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1CQMc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:32:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51872 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753768Ab1CQMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:32:27 -0400
Date: Thu, 17 Mar 2011 12:32:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 1/3] regulator: add set_voltage_time_sel infrastructure
Message-ID: <20110317123225.GC31411@opensource.wolfsonmicro.com>
References: <1300364676-27563-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300364676-27563-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 01:24:36PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This makes it possible to set the stabilization time for voltage
> regulators in the same manner as enable_time(). The interface
> only supports regulators that implements fixed selectors.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
