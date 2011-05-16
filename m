Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1EPMTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:19:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47203 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1EPMTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:19:22 -0400
Message-ID: <4DD11646.3020006@ti.com>
Date: Mon, 16 May 2011 13:19:18 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH] regulator: Only apply voltage constraints from consumers
 that set them
References: <1305405754-23256-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305405754-23256-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/11 21:42, Mark Brown wrote:
> When applying the set_voltage() requests from consumers skip over those
> consumers that haven't set anything, otherwise we'll come out with a
> maximum voltage of zero.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied.

Thanks

Liam
