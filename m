Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1KRXxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:53:31 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:44889
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697Ab1KRXxa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:53:30 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz9371K98bK98dKzz1202hzz8275ch8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Ondrej Zary <linux@rainbow-software.org>
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3.1] [resend] Resurrect Intel740 driver: i740fb
Thread-Topic: [PATCH v3.1] [resend] Resurrect Intel740 driver: i740fb
Thread-Index: AQHMpk1EjFZLP73++UO0TFFsmlZs7g==
Date: Fri, 18 Nov 2011 23:53:27 +0000
Message-ID: <CAOZdJXVx88nEAQkL13n1QXVw=kOe03QsD=pffHoZ8gecL7u8dA@mail.gmail.com>
References: <201111182154.45139.linux@rainbow-software.org>
In-Reply-To: <201111182154.45139.linux@rainbow-software.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.17.22.104]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <D75C2FCA821BCF468F5EC5AD3E7E7544@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 2:54 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Hello,
> this is an v3 attempt to resurrect an old (like 2.4.19) out-of-tree driver for
> Intel740 graphics cards and modify it for recent kernels. The old driver is
> located at: http://sourceforge.net/projects/i740fbdev/files/

Would you please run checkpatch.pl on the patch and fix the complaints
it has?  I get this:

total: 45 errors, 67 warnings, 1619 lines checked

This patch has tons of style problems.

-- 
Timur Tabi
Linux kernel developer at Freescale
