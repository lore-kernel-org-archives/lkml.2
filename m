Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2ACUUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:20:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35599 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048Ab2ACUUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:20:22 -0500
Date: Tue, 3 Jan 2012 20:20:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] regulator: add regulator_bulk_force_disable function
Message-ID: <20120103202014.GF2843@opensource.wolfsonmicro.com>
References: <1325575323-15500-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325575323-15500-1-git-send-email-dg77.kim@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 04:22:03PM +0900, Donggeun Kim wrote:
> This patch allows consumers to forcibly disable multiple regulator
> clients in a single API call.

Applied, thanks!
