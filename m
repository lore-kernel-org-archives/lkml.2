Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1C2I3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:29:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46012 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1C2I3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:29:08 -0400
Date: Tue, 29 Mar 2011 09:28:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: Propagate uA_load requirements up
	supply chain
Message-ID: <20110329082848.GA10447@n2100.arm.linux.org.uk>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org> <1301326482-6547-3-git-send-email-collinsd@codeaurora.org> <20110328180255.GA28494@opensource.wolfsonmicro.com> <20110328181415.GD31457@n2100.arm.linux.org.uk> <20110329075310.GA29330@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329075310.GA29330@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 08:53:11AM +0100, Mark Brown wrote:
> On Mon, Mar 28, 2011 at 07:14:15PM +0100, Russell King - ARM Linux wrote:
> 
> > That's not true.  Firstly, *all* regulators are not 100% efficient.  They
> > lose *power* in the form of heat.  So power into the regulator will always
> > be more than power out.
> 
> That's pretty much what I said, yes.

No, you said the power will map through but the current will not.  I'm
saying that the power will *not* map through either.
