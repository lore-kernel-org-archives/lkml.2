Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1C2IkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:40:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54694 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788Ab1C2IkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:40:02 -0400
Date: Tue, 29 Mar 2011 17:40:10 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: Propagate uA_load requirements up supply
 chain
Message-ID: <20110329084009.GA29874@opensource.wolfsonmicro.com>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
 <1301326482-6547-3-git-send-email-collinsd@codeaurora.org>
 <20110328180255.GA28494@opensource.wolfsonmicro.com>
 <20110328181415.GD31457@n2100.arm.linux.org.uk>
 <20110329075310.GA29330@opensource.wolfsonmicro.com>
 <20110329082848.GA10447@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329082848.GA10447@n2100.arm.linux.org.uk>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 09:28:48AM +0100, Russell King - ARM Linux wrote:
> On Tue, Mar 29, 2011 at 08:53:11AM +0100, Mark Brown wrote:

> > That's pretty much what I said, yes.

> No, you said the power will map through but the current will not.  I'm
> saying that the power will *not* map through either.

I said that even with a perfectly efficient regulator the current won't
map through, and that physical regulators make things even less direct.
