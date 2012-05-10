Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2EJJXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:23:30 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:34560 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab2EJJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:23:25 -0400
Message-ID: <1336641789.8605.2.camel@odin>
Subject: Re: [PATCH 1/6] regulator: core: Allow regulators to provide a
 voltage to selector mapping
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Date: Thu, 10 May 2012 10:23:09 +0100
In-Reply-To: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336607255-4967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 00:47 +0100, Mark Brown wrote:
> In order to allow more drivers to factor things out into data allow
> drivers to provide a mapping function to convert voltages into selectors.
> This allows any driver to use set_voltage_sel(). The existing mapping
> based on iterating over list_voltage() is provided as an operation which
> can be assigned to the new map_voltage() function though for ease of
> transition it is treated as the default.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

All

Acked-by: Liam Girdwood <lrg@ti.com>

