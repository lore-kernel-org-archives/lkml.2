Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1IMIVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:21:23 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:57738 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1IMIVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:21:21 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak9WAIwRb05V5qg/PGdsb2JhbABCiRueTAsBAQEBNzOBUwEBBAE6HCMFCwgDRhQNGAoaE4d3ArY0DoYAYASYZIRjhxo
X-IronPort-AV: E=Sophos;i="4.68,373,1312149600"; 
   d="scan'208";a="40190799"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Sep 2011 10:24:48 +0200
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
Message-ID: <20110913082448.GA5046@polaris.bitmath.org>
References: <1315029042-27513-1-git-send-email-martinez.javier@gmail.com>
 <1315029042-27513-2-git-send-email-martinez.javier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315029042-27513-2-git-send-email-martinez.javier@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

> Cypress TrueTouch(tm) Standard Product controllers are found in
> a wide range of embedded devices. This driver add support for a
> variety of TTSP controllers.
> 
> The driver is composed of a core driver that process the data sent by
> the contacts and a set of bus specific interface modules. This patch
> adds the base core TTSP driver.
> 
> The original author of the driver is Kevin McNeely <kev@cypress.com>
> 
> Since the hardware is capable of tracking identifiable contacts and the
> original driver used multi-touch protocol type A (stateless), multi-touch
> protocol type B (stateful) support was added by Javier Martinez Canillas.
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
> Changes since v1: Fix issues called out by Dmitry Torokhov
>      - Add msleep() delays between retries for read and write operations
>      - Change cyttsp_core_init() to receive the IRQ from the client data 
>        instead of obtaining from the platform_data

Compared to the staging version you sent earlier, this version seems
to be a step back towards the original version regarding the MT
implementation. Is this the right patch?

Thanks,
Henrik
