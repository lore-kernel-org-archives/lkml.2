Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1DEHij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:38:39 -0400
Received: from kroah.org ([198.145.64.141]:46503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1DEHig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:38:36 -0400
Date: Mon, 4 Apr 2011 23:08:44 -0700
From: Greg KH <greg@kroah.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20110405060844.GA15065@kroah.com>
References: <1301399358-10783-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301399358-10783-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 01:49:18PM +0200, Par-Gunnar Hjalmdahl wrote:
> +config CG2900_UART
> +	tristate "Support CG2900 UART transport"
> +	depends on CG2900
> +	select BT
> +	select BT_HCIUART

No, depend on this, don't have a staging driver select any other config
options, sorry.

Care to fix this up, and your drivers/staging/Kconfig fuzz in the patch
and resend it?

thanks,

greg k-h
