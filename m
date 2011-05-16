Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1EPP7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:59:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55615 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756466Ab1EPP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:59:18 -0400
Date: Mon, 16 May 2011 08:59:15 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH RESEND] regulator: Remove
 MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
Message-ID: <20110516155914.GA6725@opensource.wolfsonmicro.com>
References: <1305541234.3006.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305541234.3006.5.camel@phoenix>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 06:20:34PM +0800, Axel Lin wrote:
> In current implementation, the original macro implementation assumes the caller
> pass the parameter starting from 1 (to match the register names in datasheet).
> Thus we have unneeded plus one then minus one operations

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
