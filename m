Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab2HISFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:05:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50636 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757517Ab2HISFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:05:17 -0400
Date: Thu, 9 Aug 2012 19:05:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
Message-ID: <20120809180514.GZ24328@opensource.wolfsonmicro.com>
References: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
 <5022E0B0.1070406@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5022E0B0.1070406@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:57:04PM -0600, Stephen Warren wrote:

> I assume that was just an accident?

Probably.  I suspect a conflict with mainline when I rebased onto
v3.6-rc1.  Please resend the patch, I don't think I have it any more.
