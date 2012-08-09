Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2HISLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:11:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43151 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab2HISLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:11:08 -0400
Date: Thu, 9 Aug 2012 19:11:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
Message-ID: <20120809181106.GA24328@opensource.wolfsonmicro.com>
References: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
 <5022E0B0.1070406@wwwdotorg.org>
 <20120809180514.GZ24328@opensource.wolfsonmicro.com>
 <5023FCDB.4080607@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023FCDB.4080607@wwwdotorg.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 12:09:31PM -0600, Stephen Warren wrote:

> The patch in question just showed up again in next-20120809:

> 7f852e0 regulator: tps6586x: correct vin pin for sm0/sm1/sm2

> ... with the exact same content as the previous commit ID.

Oh, in that case I must've missed a branch when I was rebuilding -next.
I just checked for missing branches.  Problem solved.
