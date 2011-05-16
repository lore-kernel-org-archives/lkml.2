Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1EPUTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:19:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1EPUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:19:35 -0400
Subject: Re: [PATCH RESEND] regulator: Remove
 MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1305541234.3006.5.camel@phoenix>
References: <1305541234.3006.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 21:19:31 +0100
Message-ID: <1305577171.3156.15.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 18:20 +0800, Axel Lin wrote:
> In current implementation, the original macro implementation assumes the caller
> pass the parameter starting from 1 (to match the register names in datasheet).
> Thus we have unneeded plus one then minus one operations
> when using MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros.
> 
> This patch removes these macros to avoid unneeded plus one then minus one operations
> without reducing readability.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Applied.

