Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0KDOFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:05:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46996 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751106Ab0KDOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:05:43 -0400
Date: Thu, 4 Nov 2010 10:05:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        elinwal <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH] regulator: lock supply in regulator enable
Message-ID: <20101104140549.GB1201@opensource.wolfsonmicro.com>
References: <4CD2847B.1060009@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD2847B.1060009@stericsson.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:01:31AM +0100, Mattias Wallin wrote:
> This patch add locks around regulator supply enable.
> 
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> The previous patch I sent solves a problem seen in our system.
> This patch does not solve a problem I have seen but I still think
> it should be there. Or at least some locking of the supply in regulator enable.
> What do you guys think?

If we're locking the regulator when it's directly enabled we need to do
the same when enabling it via other ways.
