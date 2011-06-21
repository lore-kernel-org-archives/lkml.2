Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1FUMHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:07:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37748 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751234Ab1FUMHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:07:09 -0400
Date: Tue, 21 Jun 2011 13:07:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110621120706.GA24543@opensource.wolfsonmicro.com>
References: <20110620124608.GB31140@opensource.wolfsonmicro.com>
 <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4DFFD486.7020901@metafoo.de>
 <20110621001438.GD1905@opensource.wolfsonmicro.com>
 <4DFFE9C1.5060003@metafoo.de>
 <20110621012429.GB4322@opensource.wolfsonmicro.com>
 <20110621114709.GA12691@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621114709.GA12691@opensource.wolfsonmicro.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:47:09PM +0100, Dimitris Papastamos wrote:
> On Tue, Jun 21, 2011 at 02:24:30AM +0100, Mark Brown wrote:
> > On Tue, Jun 21, 2011 at 02:45:53AM +0200, Lars-Peter Clausen wrote:

> > > with regmap_free.

> > That's true.

> In the soc-cache code we use _init and _exit respectively.  Might be
> worth considering instead of _free?

Err, yes - that's what I said :)
