Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2HVMfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:35:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2HVMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:35:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [RESEND PATCH v4 0/2] omap: add ocp2scp as a bus driver
Date: Wed, 22 Aug 2012 12:34:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com,
        rob@landley.net, linux@arm.linux.org.uk, ohad@wizery.com,
        linus.walleij@linaro.org, myungjoo.ham@samsung.com,
        rusty@rustcorp.com.au, swarren@nvidia.com
References: <1345624803-16379-1-git-send-email-kishon@ti.com>
In-Reply-To: <1345624803-16379-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221234.31193.arnd@arndb.de>
X-Provags-ID: V02:K0:YkG4bNHU+5g2+IhoIFymyY6WhmN84soomg0wmQvbtox
 8X0huRDumpkMW3qW/+cZEAUrIGiLW52DypxdKq2tdYAR0JiG9R
 KgikSYspcHt82YwiAjKCVxbBPbo/Ru/EQ6gOqruh8u60FVnNSA
 zJMOj4qml+xH6tZMS5PaxaLPfb4d65GV0IhTjxyFYvwQgdqmNa
 30czRw6h31NJXpu/6z+b4P6orTYPxiBBHR4bJn6gFotRugKRQb
 O93HQ+pfqSS5PQLvYoBbOK6n+9KEqJ+2FkWZkSfnvoMft/313j
 K01mFF4n8hup3Vfgrqx7zlMLtzNuNbUH0Y8/tyy1iu6H/HKghY
 BBMiesXEVaPCAuYrqTm0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Kishon Vijay Abraham I wrote:
> This patch series has been lying here for long. If no one has any
> comments on this patch series, can someone pick it up?

I've added them now as a drivers/ocp2scp branch arm-soc and pulled
them into the next/drivers topic branch.

	Arnd
