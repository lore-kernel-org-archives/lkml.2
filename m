Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab2EaNFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:05:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44763 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2EaNFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:05:01 -0400
Date: Thu, 31 May 2012 14:04:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531130456.GB15786@sirena.org.uk>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5DFCF.1020606@codeaurora.org>
 <20120531075125.GL8026@tbergstrom-lnx.Nvidia.com>
 <20120531081841.GG5377@arwen.pp.htv.fi>
 <20120531083131.GQ8026@tbergstrom-lnx.Nvidia.com>
 <20120531085432.GK5377@arwen.pp.htv.fi>
 <20120531090518.GR8026@tbergstrom-lnx.Nvidia.com>
 <4FC768F8.4050406@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC768F8.4050406@ti.com>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 02:50:00PM +0200, Cousson, Benoit wrote:

> Now the question is should we extend the Linux device structure to
> handle such HW IP, or should we extend the clock definition to
> handle this kind of extended clock node.

> It looks to me that this kind of function does belong to the device
> more than to the clock node.

This is looking a lot like what power domains do to me...
