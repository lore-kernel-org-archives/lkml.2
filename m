Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1HSQcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:32:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab1HSQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:32:45 -0400
Date: Fri, 19 Aug 2011 20:32:40 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Woodhouse <dwmw2@infradead.org>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Only register WM831x battery charger if
 enabled
Message-ID: <20110819163240.GD22761@oksana.dev.rtsoft.ru>
References: <1313451462-15672-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1313451462-15672-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 08:37:42AM +0900, Mark Brown wrote:
> Don't tell the system about the battery charger if it's not enabled, we
> can reasonably assume that if the charger is not enabled then no battery
> will ever be connected so reporting state is at best going to waste time
> and at worst going to cause confusing information in the UI.
> 
> For simplicity and robustness we continue to register and handle interrupts
> from the charger.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
