Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1GOEhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 00:37:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33826 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080Ab1GOEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 00:37:04 -0400
Date: Fri, 15 Jul 2011 13:36:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v3] regulator: Fix memory leak in
 set_machine_constraints() error paths
Message-ID: <20110715043651.GI32716@opensource.wolfsonmicro.com>
References: <1310698243.2384.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310698243.2384.1.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:50:43AM +0800, Axel Lin wrote:
> Properly kfree rdev->constraints in all set_machine_constraints() error paths.
> Also properly kfree rdev->constraints in regulator_register() error paths.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
