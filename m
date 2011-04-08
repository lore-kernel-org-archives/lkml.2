Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1DHQAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:00:39 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:27374
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757233Ab1DHQAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:00:37 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 8 Apr 2011 10:59:52 -0500
From: Scott Wood <scottwood@freescale.com>
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        <aarcange@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <joro@8bytes.org>, <penberg@cs.helsinki.fi>, <asias.hejun@gmail.com>,
        <gorcunov@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110408105952.5e7c2ffb@schlenkerla.am.freescale.net>
In-Reply-To: <4D9E6F6E.9050709@codemonkey.ws>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011 21:14:06 -0500
Anthony Liguori <anthony@codemonkey.ws> wrote:

> If someone was going to seriously go about doing something like this, a 
> better approach would be to start with QEMU and remove anything non-x86 
> and all of the UI/command line/management bits and start there.
> 
> There's nothing more I'd like to see than a viable alternative to QEMU 
> but ignoring any of the architectural mistakes in QEMU and repeating 
> them in a new project isn't going to get there.

Supporting only a single architecture sounds like a significant
architectural mistake...  only x86 deserves clean code?

-Scott

