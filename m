Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2HTHlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:41:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47023 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab2HTHlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:41:40 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Topic: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Index: Ac1+iI3X+iN5rabESjyXTrhr06HT3P//lKUAgAAFuYD//3VuQIAApKsA//95ceA=
Date: Mon, 20 Aug 2012 07:41:31 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF096C@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
 <20120820055817.GA17149@avionic-0098.adnet.avionic-design.de>
 <A874F61F95741C4A9BA573A70FE3998F41EF0939@DQHE02.ent.ti.com>
 <20120820073141.GA27645@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120820073141.GA27645@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe we should get this resolved somehow in the meantime. Resolving
> the
> other issues may take another cycle or two, so you may not want to wait
> that long.

Is that job also including HAVE_PWM configurations?
Some SoCs still set HAVE_PWMs and codes exist under arch/ directory.
As I far as understand, new PWM subsystem uses CONFIG_PWM not HAVE_PWM, right?
And then will HAVE_PWM be cleaned-up?

Best Regards,
Milo



