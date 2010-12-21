Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab0LULa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:30:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42690 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750742Ab0LULa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:30:57 -0500
Date: Tue, 21 Dec 2010 11:30:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Axel Lin <axel.lin@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] regulator: max8952 - fix max8952_set_voltage check
 condition.
Message-ID: <20101221113054.GC13696@rakim.wolfsonmicro.main>
References: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292907880-3353-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Contents may settle during shipment.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 02:04:39PM +0900, MyungJoo Ham wrote:
> In the current implementation, the GPIO pin, vid0 is checked twice
> (duplicated!) while vid1 is never checked; however, both vid0 and
> vid1 should be checked. This patch fixes the typo that stated vid0 where
> should've stated vid1.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
