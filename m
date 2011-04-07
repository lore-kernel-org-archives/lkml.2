Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1DGLiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:38:11 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11867 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568Ab1DGLiJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:38:09 -0400
From: "Boivie, Victor" <Victor.Boivie@sonyericsson.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Paul Bolle <pebolle@tiscali.nl>
CC: =?iso-8859-1?Q?=22Ander=F6=2C_Oskar=22?= 
	<Oskar.Andero@sonyericsson.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 7 Apr 2011 13:38:05 +0200
Subject: RE: [PATCH] ARM: Allow for kernel command line concatenation
Thread-Topic: [PATCH] ARM: Allow for kernel command line concatenation
Thread-Index: Acv1EtYelM98O64wQ6qoQ3Exu3E4MQABFjjw
Message-ID: <56A05FDF86209947BB88FDF67E6D4A1073F0B97360@SELDMBX04.corpusers.net>
References: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
 <1302172525.24493.7.camel@t41.thuisdomein>
 <20110407105850.GJ13963@pengutronix.de>
In-Reply-To: <20110407105850.GJ13963@pengutronix.de>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This suggests the parameters provided by the boot loader will override
> > corresponding parameters of the default kernel command string. Is that
> > correct (for all possible parameters)?
> >
> > Either way, shouldn't it be documented, perhaps in this help text, what
> > will happen if a parameter of the default kernel command string and a
> > parameter provided by the boot loader somehow conflict?
> Then you will end up with both parameters I guess. What happens depends
> on the parameter in question I guess. IMHO the description is fine.
> But I wonder if the new mechanism is useful in the end.

The way it was intended from my point of view was to only specify (in 
CONFIG_CMDLINE) the parameters that the boot loader doesn't specify. 

We use it to let the boot loader (which is generic and whose config is
rather tricky to change) specify startup reasons and other probed 
information that the kernel can't probe itself, and let the kernel handle
the rest, such as specifying memory regions and console tty's.

Thanks for reviewing, both of you.

Best regards,
Victor Boivie
