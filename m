Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1E1R4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:56:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52250 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754487Ab1E1R4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:56:19 -0400
Date: Sun, 29 May 2011 01:56:14 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: twl-regulator: fix n_voltages for twl6030
 variable LDOs
Message-ID: <20110528175613.GA31225@opensource.wolfsonmicro.com>
References: <1306524327-24150-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306524327-24150-1-git-send-email-ccross@android.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 12:25:27PM -0700, Colin Cross wrote:
> The n_voltages initializer for the TWL6030_ADJUSTABLE_LDO macro is
> off by one, causing the the highest supported voltage to be
> unreachable.  Setting the machine constraints to only allow the
> highest voltage causes errors:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
