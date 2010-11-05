Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0KEN7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:59:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41439 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751937Ab0KEN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:59:48 -0400
Date: Fri, 5 Nov 2010 09:59:55 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 2/3 v2] regulator: Ensure enough delay time for
 enabling regulator
Message-ID: <20101105135954.GA15977@opensource.wolfsonmicro.com>
References: <1288965092.2312.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288965092.2312.3.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 09:51:32PM +0800, Axel Lin wrote:
> Integer division will truncate the result, this patch ensures we have
> enough delay time for enabling regulator.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
