Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab1FHT2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:28:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40335 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab1FHT2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:28:37 -0400
Message-ID: <4DEFCD5F.4030606@ti.com>
Date: Wed, 8 Jun 2011 20:28:31 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Properly register dummy regulator driver
References: <1307486178-29718-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1307486178-29718-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/11 23:36, Mark Brown wrote:
> Recent changes in the driver core appear to mean that the data structures
> for the driver core are not fully initialised unless the driver is bound.
> Make sure the driver core knows the dummy driver is in use by binding it
> to a driver.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied

Thanks

Liam
