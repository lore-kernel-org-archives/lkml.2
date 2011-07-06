Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1GFLMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:12:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1GFLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:12:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: Please submit platform trees for inclusion in arm-soc.git v3.1
Date: Wed, 6 Jul 2011 13:12:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
References: <201107012018.14619.arnd@arndb.de> <B85A65D85D7EB246BE421B3FB0FBB593024D91AB83@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D91AB83@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061312.01852.arnd@arndb.de>
X-Provags-ID: V02:K0:y7OQsVHQABegOHkCI6B1ZxT/dqHzjcuYMQEqV1HFv9C
 v6S40C2BjzNELXwJfD/B25oGVBgXwNEopSfIwK+f2AjuiGUGtn
 MlbqfJn4Gv9nmYWJU0IijxRRnEDQatBerlbPeNX5GBAauvG8RO
 Df1r6R7CTPjzI0CNweEuL5Va+9pna8rddlN6o+RjdDV0X/4DiY
 YYZgNYBUGXwmM4YpTb+Vw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 July 2011, Nori, Sekhar wrote:
> On Fri, Jul 01, 2011 at 23:48:14, Arnd Bergmann wrote:
> 
> > * If you currently merge your patches upstream through RMK's tree,
> >   you can keep doing so.
> 
> We currently send DaVinci patches upstream through Russell.
> This makes it look like the change applies only to those
> maintainers who were sending patches to Linus directly.
> 
> I want to make sure I read this correctly and should continue
> sending patches upstream through Russell?

You are welcome to submit patches to the arm-soc tree instead of
Russell's if you prefer to do so, either way is fine with me
at least.

The arm-soc tree was introduced mostly to reorganize the upstream
merge process for those platforms that directly send patches to
Linus, but we can also do it for everyone else.

We probably still need to try out a few things and see how it goes.
Russell also has write access to the arm-soc tree, so one of the
possible models is that you send the patches to him, but he adds
them to the arm-soc tree rather than the arm-linux one.

Russell, do you have a preference? If you want to stop merging
subarch trees into linux-arm.git, we can do that in arm-soc.git.
The idea behind my suggestion to keep using your tree was to not
change too many things at once, and we can always revisit this
question.

	Arnd
