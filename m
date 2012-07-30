Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2G3Rlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:41:46 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:48515 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab2G3RlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:41:21 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2012 13:41:20 EDT
Date: Mon, 30 Jul 2012 21:32:32 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>,
        GregKH <greh@kroah.com>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in
 platform data
Message-ID: <20120730173232.GA20809@ioremap.net>
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
