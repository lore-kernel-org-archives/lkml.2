Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2HIK7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 06:59:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56895 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757847Ab2HIK7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 06:59:13 -0400
Date: Thu, 9 Aug 2012 11:59:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 2/3] regulator: add regulator_get_voltage_fixed helper
 op
Message-ID: <20120809105910.GN24328@opensource.wolfsonmicro.com>
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org>
 <1344460727-6243-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344460727-6243-2-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:18:46PM -0600, Stephen Warren wrote:

> Fixed regulators always output desc->min_uV. Add a helper get_voltage
> op to save duplicating this code in drivers.

Just use get_voltage_linear() (or convert the existing users).
