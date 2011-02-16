Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1BPWoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:44:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:39168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1BPWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:44:43 -0500
Subject: Re: [PATCH v3] olpc_battery: convert to platform device
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Drake <dsd@laptop.org>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dilinger@queued.net, dmitry.torokhov@gmail.com
In-Reply-To: <20110216222820.487AE9D401C@zog.reactivated.net>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 22:44:37 +0000
Message-ID: <1297896277.3011.5.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 22:28 +0000, Daniel Drake wrote:
> 
> +static int __init add_common_platform_devices(void)
> +{
> +       struct platform_device *pdev;
> +
> +       pdev = platform_device_register_simple("olpc-battery", -1, NULL, 0);
> +       if (IS_ERR(pdev))
> +               return PTR_ERR(pdev);
> +
> +       return 0;
> +}
> + 

Still kind of sucks that you have to do this, and can't bind to
something in the device-tree.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

