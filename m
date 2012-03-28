Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2C1ARv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:17:51 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:43593
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab2C1ARu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:17:50 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz9371I936eK542M1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1KJHK-01-EUU-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>
Subject: RE: [BUG] Warning at radeon_object.c:236 with latest Linus kernel
Thread-Topic: [BUG] Warning at radeon_object.c:236 with latest Linus kernel
Thread-Index: AQHNDHe5zMnotxtFJkGQj3UfsikYSJZ/KuQA//+sbwA=
Date: Wed, 28 Mar 2012 00:17:43 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D013853C30@sausexdag01.amd.com>
References: <1332893642.23924.139.camel@gandalf.stny.rr.com>
 <1332893782.23924.140.camel@gandalf.stny.rr.com>
In-Reply-To: <1332893782.23924.140.camel@gandalf.stny.rr.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.181.250.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Tuesday, March 27, 2012 8:16 PM
> To: LKML
> Cc: dri-devel; David Airlie; Daenzer, Michel; Deucher, Alexander
> Subject: Re: [BUG] Warning at radeon_object.c:236 with latest Linus kernel
> 
> On Tue, 2012-03-27 at 20:14 -0400, Steven Rostedt wrote:
> > You can get the full dmesg here:
> >
> > http://rostedt.homelinux.com/private/dmesg-bxf-20120327
> 
> 
> And the config is here:
> 
> http://rostedt.homelinux.com/private/config-bxf-20120327

Can you try this patch:
http://lists.freedesktop.org/archives/dri-devel/2012-March/020606.html

Alex

> 
> -- Steve
> 
> 


