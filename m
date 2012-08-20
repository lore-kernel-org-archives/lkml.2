Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2HTGQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:16:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43173 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2HTGQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:16:50 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Bryan Wu <bryan.wu@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Topic: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Index: Ac1+iI3X+iN5rabESjyXTrhr06HT3P//lKUAgAAFuYD//3VuQA==
Date: Mon, 20 Aug 2012 06:16:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0939@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
 <20120820055817.GA17149@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120820055817.GA17149@avionic-0098.adnet.avionic-design.de>
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

> > * Rather than having to do the #ifdef here, I think it would be
> better if
> >   the PWM subsystem provided stub functions for pwm_request,
> pwm_config,
> >   pwm_enable, pwm_disable and pwm_free that do nothing, so you can in
> effect
> >   let the compiler optimize away the above code.
> 
> That's actually on my TODO list, but I think it needs to wait until we
> have gotten rid of all legacy implementations. The stubs would have to
> move into the !CONFIG_PWM branch, which will in turn break because the
> legacy implementations would provide non-inlined duplicates.
> 
> Thierry

OK, then it's better to wait fixing that first.

Bryan,
please just ignore this patch.
I'll resend the patch later.

Thank you.

Best Regards,
Milo



