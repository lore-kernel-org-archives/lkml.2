Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2H0SWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:22:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57564 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623Ab2H0SWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:22:22 -0400
Date: Mon, 27 Aug 2012 11:22:18 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Axel Lin <axel.lin@gmail.com>, Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max8907: fix use of possibly NULL idata
Message-ID: <20120827182217.GY4339@opensource.wolfsonmicro.com>
References: <1345745958-16782-1-git-send-email-swarren@wwwdotorg.org>
 <5036758F.1030507@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036758F.1030507@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:25:19PM -0600, Stephen Warren wrote:

> If I interpreted Mark Brown correctly, this isn't correct; all the
> regulators within the chip should always be registered, just without any
> user-supplied constraints. Assuming I didn't misinterpret Mark, can you

That's what I meant, yes.
