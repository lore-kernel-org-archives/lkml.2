Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab2DMJVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:21:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33171 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2DMJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:21:03 -0400
Date: Fri, 13 Apr 2012 10:21:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: arnd.bergmann@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 00/13] common clk framework misc fixes
Message-ID: <20120413092100.GA22485@sirena.org.uk>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
X-Cookie: Money is its own reward.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:02:38PM -0700, Mike Turquette wrote:
> This series collects many of the fixes posted for the recently merged
> common clock framework as well as some general clean-up.  Most of the
> code classifies as a clean-up moreso than a bug fix; hopefully this is
> not a problem since the common clk framework is new code pulled for 3.4.

Can you please CC people on your cover letters as well as on the
individual patches?
