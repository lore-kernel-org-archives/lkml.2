Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0LLNw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:52:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58090 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752736Ab0LLNwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:52:54 -0500
Date: Sun, 12 Dec 2010 13:53:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Call into regulator driver only when
 voltage min/max really changes.
Message-ID: <20101212135305.GI15189@opensource.wolfsonmicro.com>
References: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 02:55:40AM -0800, Saravana Kannan wrote:
> Even in cases where the consumer driver calls the regulator core with
> different voltage min/max values, the application of the various
> voltage constraints could result in the min/max voltage values passed
> to the regulator driver to be unchanged since the previous invocation.

So, I tried to apply this against my local tree to avoid collisions with
it but it doesn't apply so I suspect Liam will have trouble also, there
are several updates in there that overlap with your change.  Please
regenerate against -next or Liam's tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6

You should always submit changes against the development versions of
code, generally -next will have these merged into it.
