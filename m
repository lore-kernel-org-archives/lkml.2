Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2ILU1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:27:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31310 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751901Ab2ILU1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:27:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sMOvRd8Cd4WddvRoWN5MF
Date: Wed, 12 Sep 2012 13:27:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
Message-ID: <20120912202700.GD5997@atomide.com>
References: <1347353664-15906-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347353664-15906-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120911 01:54]:
> With pinctrl-single,bits it is possible to update just part of the register
> within the pinctrl-single,function-mask area.
> This is useful when one register configures mmore than one pin's mux.

>  	size /= sizeof(*mux);	/* Number of elements in array */
> -	rows = size / 2;	/* Each row is a key value pair */
> +	rows = size / params;	/* Each row is a key value pair */

Maybe just remove the comment:  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I don't think it's needed any longer. Other than that,
thanks for updating the patch:

Acked-by: Tony Lindgren <tony@atomide.com>
