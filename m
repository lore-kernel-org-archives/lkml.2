Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1DOKAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:00:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35613 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753862Ab1DOKAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:00:43 -0400
Date: Fri, 15 Apr 2011 11:00:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Group TI TPSxxxxx regulators together
Message-ID: <20110415100043.GE23466@opensource.wolfsonmicro.com>
References: <1302829078.2752.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302829078.2752.6.camel@phoenix>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 08:57:58AM +0800, Axel Lin wrote:
> Group TI TPSxxxxx regulators together and sort in alphabetical order.
> This change make it easier for users to find the config options.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
