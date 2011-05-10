Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1EJL1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:27:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39893 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752764Ab1EJL1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:27:30 -0400
Date: Tue, 10 May 2011 13:27:35 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] Revert "regulator: Move VCOINCELL to be the last element
 of mc13892_regulators array"
Message-ID: <20110510112734.GA7587@opensource.wolfsonmicro.com>
References: <1305025836.2569.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305025836.2569.2.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 07:10:36PM +0800, Axel Lin wrote:
> I check this patch again and found this actually is not a bug
> because MC13xxx_DEFINE explictly defines the order of each entry in the array.
> 
> Thus revert the patch.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but this seems like something error prone that we probably want to
consider fixing anyway?
