Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1ECQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57890 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752784Ab1ECQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:08:49 -0400
Date: Tue, 3 May 2011 17:08:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] msm: board-8960: Add support for
 pm8921-regulator
Message-ID: <20110503160845.GA1762@opensource.wolfsonmicro.com>
References: <1304118421-18764-1-git-send-email-collinsd@codeaurora.org>
 <1304118667-19322-1-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304118667-19322-1-git-send-email-collinsd@codeaurora.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 04:11:07PM -0700, David Collins wrote:

> +PM8921_VREG_CONSUMERS(L1) = {
> +	REGULATOR_SUPPLY("8921_l1",		"reg-debug-consumer"),
> +};

Uh, no.  There's no such thing in mainline and having such a thing
enabled in production builds is crazy.  If such a thing *did* exist it
should still be doing the same thing everything else does and requesting
a fixed supply name.
