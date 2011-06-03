Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1FCRha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:37:30 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56589 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab1FCRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:37:28 -0400
Date: Fri, 3 Jun 2011 11:37:25 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] gpio: 74x164: remove unnecessary defines and prototype
Message-ID: <20110603173725.GC15616@ponder.secretlab.ca>
References: <201105271635.59593.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105271635.59593.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 04:35:59PM -0700, H Hartley Sweeten wrote:
> Remove the #define GEN_74X164_GPIO_COUNT since it's only used in
> one place and it's meaning is obvious.  Also remove the #define
> GEN_74X164_DRIVER_NAME and use spi->modalias to set the gpio chip's
> label and the string "74x164" for the driver name.
> 
> Reorder the code slightly to remove the need to prototype
> gen_74x164_set_value.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks.

g.

