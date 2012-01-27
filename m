Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2A0Ijq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:39:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44762 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2A0Ijo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:39:44 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Colin Cross <ccross@android.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Thread-Topic: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Thread-Index: AQHM3Efdz4WGVcb5lUWhYfrRza69QJYfx+nQ//+o9gCAAHHaUA==
Date: Fri, 27 Jan 2012 08:39:28 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D1214331791FA2@DBDE01.ent.ti.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
	<1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
	<B5906170F1614E41A8A28DE3B8D1214331791EA6@DBDE01.ent.ti.com>
 <CAMbhsRQ00Cm-wo9hL9jRfpUfATPZc+znNJu-EagK6qV0qRs4SA@mail.gmail.com>
In-Reply-To: <CAMbhsRQ00Cm-wo9hL9jRfpUfATPZc+znNJu-EagK6qV0qRs4SA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:40:58, Colin Cross wrote:
> local_irq_enable() is required by the cpuidle call semantics.  See
> arch/arm/process.c, it has a 				WARN_ON(irqs_disabled()) after the
> idle function call.  The local_irq_disable() can and probably should
> be dropped, although a comment that the function is called with
> interrupts off and is expected to return with interrupts on would be
> helpful.
> 

Ah... I was too fixated on local_irq_disable() and local_irq_enable() in cpu_idle().
Thanks for clarifying.
