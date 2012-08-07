Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2HGRIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:08:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56831 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab2HGRIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:08:05 -0400
Date: Tue, 7 Aug 2012 18:08:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Fix cast to pointer from integer of
 different size warning
Message-ID: <20120807170802.GA16861@opensource.wolfsonmicro.com>
References: <1344267859.9376.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344267859.9376.3.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:44:19PM +0800, Axel Lin wrote:
> This is to address the following warning during compilation time: (Compile on x86_64)

Applied, thanks.
