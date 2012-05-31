Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab2EaJ6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:58:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9355 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2EaJ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:58:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 31 May 2012 02:57:58 -0700
Date: Thu, 31 May 2012 12:57:23 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531095723.GU8026@tbergstrom-lnx.Nvidia.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
 <20120531092603.GM5377@arwen.pp.htv.fi>
 <20120531094301.GT8026@tbergstrom-lnx.Nvidia.com>
 <20120531094616.GP5377@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120531094616.GP5377@arwen.pp.htv.fi>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Well, that's just because struct device doesn't know about its own clock
> providers, right ? Should that be patched too ?
> 
> Russell, as the orignal author of the clk API, what do you think ?

Even if it would know, how would that solve the problem? only the
clockframework is supposed to know about struct clk.

Cheers,

Peter.
