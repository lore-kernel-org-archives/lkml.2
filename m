Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab2AFS7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:59:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57795 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756639Ab2AFS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:59:41 -0500
Date: Fri, 6 Jan 2012 10:59:28 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan.com@nvidia.com>
Cc: lrg@slimlogic.co.uk, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ldewangan@nvidia.com
Subject: Re: [PATCH V3] regulator: TPS62360: Add tps62360 regulator driver
Message-ID: <20120106185927.GD2893@opensource.wolfsonmicro.com>
References: <1325776504-31738-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325776504-31738-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:45:04PM +0530, Laxman Dewangan wrote:
> From: Laxman Dewangan <ldewangan@nvidia.com>
> 
> The regulator module consists of 1 DCDC. The output voltage
> is configurable and is meant for supply power to the core
> voltage of Soc.

This looks a lot better but please see my comments on vsel in reply to
your earlier e-mail.  I've no issues with this other than the ones that
are still under discussion for v2.
