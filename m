Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1EWOdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:33:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34853 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754740Ab1EWOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:33:32 -0400
Date: Mon, 23 May 2011 22:33:26 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v3] regulator: Fix _regulator_get_voltage if get_voltage
 callback is NULL
Message-ID: <20110523143323.GA17298@opensource.wolfsonmicro.com>
References: <1306152491.2968.9.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306152491.2968.9.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 08:08:10PM +0800, Axel Lin wrote:
> In the case of get_voltage callback is NULL, current implementation in
> _regulator_get_voltage will return -EINVAL.
> 
> Also returns proper error if ret is negative value.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
