Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579Ab2HXOVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:21:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab2HXOVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:21:36 -0400
Message-ID: <50378DD1.9080806@suse.cz>
Date: Fri, 24 Aug 2012 16:21:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Input: cyttsp4 - core driver for Cypress TMA4XX touchscreen
 devices
References: <Ferruh Yigit <fery@cypress.com> <1344345000-30494-1-git-send-email-fery@cypress.com>
In-Reply-To: <1344345000-30494-1-git-send-email-fery@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 7.8.2012 15:09, Ferruh Yigit napsal(a):
> +static int __init cyttsp4_core_init(void)
> +{
> +       int rc = 0;
> +
> +       rc = cyttsp4_register_core_driver(&cyttsp4_core_driver);
> +       pr_info("%s: Cypress TTSP v4 core driver (Built %s @ %s) rc=%d\n",
> +                __func__, __DATE__, __TIME__, rc);

Hi,

please drop the __DATE__ and __TIME__ macros to keep the build
deterministic.

thanks,
Michal
