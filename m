Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2GNDdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:33:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46664 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab2GNDdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:33:03 -0400
Date: Fri, 13 Jul 2012 20:30:55 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Saranya Gopal <saranya.gopal@intel.com>
Cc: lars@metafoo.de, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] bq27x00_battery: Add support for BQ27425 chip
Message-ID: <20120714033055.GA20018@lizard>
References: <1341549392-22170-1-git-send-email-saranya.gopal@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1341549392-22170-1-git-send-email-saranya.gopal@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:06:32AM +0530, Saranya Gopal wrote:
> This patch adds support for BQ27425 (TI) chip. This chip is same as
> BQ27500 with few registers removed and register address map changed.
> The data sheet for this chip is publicly available at
>  http://www.ti.com/product/bq27425-g1
> 
> Changes since v3:
> 	Add bq27xxx as prefix for the newly added function.
> 	Define SOC register address plus offset for bq27425 instead
> 	   of register address alone to align with other register reads.
> 
> Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> ---

Applied w/ Reviewed-by: Lars-Peter Clausen <lars@metafoo.de> tag.

Saranya, thanks for the patch! And much thanks to Lars-Peter for the
review work!

p.s.
Saranya, one thing though: I had to fixup a small conflict in the
patch since you seem to prepared the patch against Linus' tree, but
there are some changes in the battery tree for this driver. Please
check if I fixed the conflict in a proper way. :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
