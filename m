Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2IGPDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:03:22 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:51044 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384Ab2IGPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:03:18 -0400
Message-ID: <1347030189.4625.0.camel@odin>
Subject: Re: [PATCH] regulator: core: Fast path non-deferred disables
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 16:03:09 +0100
In-Reply-To: <1346986880-28846-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1346986880-28846-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 11:01 +0800, Mark Brown wrote:
> Users (especially framework code) may end up passing in a zero deferral
> time depending on runtime conditions or configuration. If they do then
> just call regulator_disable() directly to save scheduling.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Liam Girdwood <lrg@ti.com>

