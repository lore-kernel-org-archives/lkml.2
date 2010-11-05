Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0KENSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:18:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38504 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754155Ab0KENST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:18:19 -0400
Date: Fri, 5 Nov 2010 09:18:25 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/3] regulator: Remove a redundant device_remove_file
 call in create_regulator
Message-ID: <20101105131824.GC13709@opensource.wolfsonmicro.com>
References: <1288941912.16201.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288941912.16201.1.camel@mola>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 03:25:12PM +0800, Axel Lin wrote:
> We already have device_remove_file() in error path,
> no need to call it before goto link_name_err.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
