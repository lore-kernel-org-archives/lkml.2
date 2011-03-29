Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1C2HxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:53:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37729 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751448Ab1C2HxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:53:06 -0400
Date: Tue, 29 Mar 2011 08:53:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] regulator: Propagate uA_load requirements up supply
 chain
Message-ID: <20110329075310.GA29330@opensource.wolfsonmicro.com>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
 <1301326482-6547-3-git-send-email-collinsd@codeaurora.org>
 <20110328180255.GA28494@opensource.wolfsonmicro.com>
 <20110328181415.GD31457@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328181415.GD31457@n2100.arm.linux.org.uk>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 07:14:15PM +0100, Russell King - ARM Linux wrote:

> That's not true.  Firstly, *all* regulators are not 100% efficient.  They
> lose *power* in the form of heat.  So power into the regulator will always
> be more than power out.

That's pretty much what I said, yes.
