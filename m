Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2G3SMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 14:12:41 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:48671 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab2G3SMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 14:12:40 -0400
Date: Mon, 30 Jul 2012 22:12:39 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in
 platform data
Message-ID: <20120730181238.GA23443@ioremap.net>
References: <1343249670-14985-1-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343249670-14985-1-git-send-email-zonque@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for long delay
[resend with fixed Greg's address :)]

On Wed, Jul 25, 2012 at 10:54:29PM +0200, Daniel Mack (zonque@gmail.com) wrote:
> In the process of porting boards to devicetree implemenation, we should
> keep information about external circuitry where they belong - the
> individual drivers.
> 
> This patch adds a way to specify a GPIO to drive the (optional) external
> pull-up logic, rather than using a function pointer for that.

I do not object against this patch, but I have rather limited knowledge
about gpio driver. Patch looks good, feel free to add my
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Greg, please pull it into your tree, if Ville does not object.
Thank you.

-- 
	Evgeniy Polyakov
