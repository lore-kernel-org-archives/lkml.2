Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422705Ab2KNL6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:58:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42566 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422673Ab2KNL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:58:03 -0500
Date: Wed, 14 Nov 2012 20:57:55 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Frank Li <Frank.Li@freescale.com>
Subject: Re: [PATCH 1/1] regulator: gpio-regulator: Catch 'no states
 property' misuse
Message-ID: <20121114115754.GA11196@opensource.wolfsonmicro.com>
References: <1352893896-15956-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352893896-15956-1-git-send-email-lee.jones@linaro.org>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 11:51:36AM +0000, Lee Jones wrote:
> A selection of voltage or current values (AKA states) should always
> be specified when using a GPIO regulator. If there are no switchable
> states then the fixed regulators should be used instead.

Applied, thanks.
