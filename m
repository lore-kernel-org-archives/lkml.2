Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2GJMnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:43:32 -0400
Received: from antcom.de ([188.40.178.216]:36088 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2GJMn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:43:28 -0400
Message-ID: <4FFC236E.7090308@antcom.de>
Date: Tue, 10 Jul 2012 14:43:26 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] pwm: add lpc32xx pwm support
References: <1341921212-11953-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1341921212-11953-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 07/10/2012 01:53 PM, Alexandre Pereira da Silva wrote:
> Add lpc32xx soc pwm driver.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -0,0 +1,150 @@
> +/*
> + * Copyright 2012 Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html

Some nitpicking about legal wording and contents:

It doesn't state explicitly that we are licensing via GPLv2.

Further, maybe we can drop the links (which can become obsolete in the
future)? We are shipping the GPL anyway, and other drivers also don't
need links.

E.g.:

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2.

Please also consider Thierry's comments.

Thanks for the driver!

Roland
