Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1CZRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 13:16:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57637 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753162Ab1CZRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 13:16:57 -0400
Date: Sat, 26 Mar 2011 17:17:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@smasung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Add MODULE_DEVICE_TABLE to max8997 and max8998
Message-ID: <20110326171708.GA2700@opensource.wolfsonmicro.com>
References: <1301153322.3302.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301153322.3302.3.camel@phoenix>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 11:28:42PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
