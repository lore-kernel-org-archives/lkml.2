Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab2GFR0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:26:45 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:47407 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932196Ab2GFR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:26:43 -0400
Message-ID: <1341595513.4963.12.camel@odin>
Subject: Re: [PATCH] regulator: core: Mark all DT based boards as having
 full constraints
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 18:25:13 +0100
In-Reply-To: <1341595230-2069-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341595230-2069-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 18:20 +0100, Mark Brown wrote:
> Since DT doesn't provide an idiomatic mechanism for enabling full
> constraints and since it's much more natural with DT to provide them
> just assume that a DT enabled system has full constraints.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Liam Girdwood <lrg@ti.com>

