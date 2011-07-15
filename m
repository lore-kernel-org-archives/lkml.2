Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1GOCno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:43:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56439 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932217Ab1GOCnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:43:43 -0400
Date: Fri, 15 Jul 2011 11:43:32 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix memory leak in set_machine_constraints()
 error paths
Message-ID: <20110715024330.GG32716@opensource.wolfsonmicro.com>
References: <1310650159.6854.1.camel@phoenix>
 <20110714234805.GA32716@opensource.wolfsonmicro.com>
 <CAF+7xWnOZkOpMSiOBJKA2HMpstzqUt1GT3Gr+g783trYH+kj3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWnOZkOpMSiOBJKA2HMpstzqUt1GT3Gr+g783trYH+kj3A@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 08:44:53AM +0800, Axel Lin wrote:

> I think it does checking null pointer for rdev->constraints in current
> implementation:

So, then does this perhaps open paths where ret might be used
uninitialized?  In general this seems like an unrelated stylistic change
which is unfortunately hard to review from a context diff alone.
