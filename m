Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2LSRes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:34:48 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60561 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2LSRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:34:43 -0500
Message-ID: <1355938492.27893.8.camel@gitbox>
Subject: Re: Inconsistency in clk framework
From: Tony Prisk <linux@prisktech.co.nz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Arm Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 20 Dec 2012 06:34:52 +1300
In-Reply-To: <20121219092636.GW14363@n2100.arm.linux.org.uk>
References: <1355890233.25599.4.camel@gitbox>
	 <20121219092636.GW14363@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 09:26 +0000, Russell King - ARM Linux wrote:
> On Wed, Dec 19, 2012 at 05:10:33PM +1300, Tony Prisk wrote:
> > Hi Mike,
> > 
> > In attempting to remove some IS_ERR_OR_NULL references, it was pointed
> > out that clk_get() can return NULL if CONFIG_HAVE_CLK is not defined.
> 
> That is correct - but why is that a problem?  As far as users are
> concerned, NULL is a valid clock.  If HAVE_CLK is undefined, do you
> want all your drivers to suddenly stop working?

That will be where the misunderstanding has occurred - I didn't consider
NULL to be a valid clock.

Given that NULL is a valid clock, I guess all tests against get_clk and
of_get_clk results should be IS_ERR_OR_NULL. Correct?

Regards
Tony P

