Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2D3F0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:26:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:45860 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2D3F0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:26:23 -0400
Message-ID: <1335763568.20866.37.camel@pasglop>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: kaffeemonster@googlemail.com
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        matt@ozlabs.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 30 Apr 2012 15:26:08 +1000
In-Reply-To: <4F9E188E.80503@googlemail.com>
References: <4F75CA89.4010709@googlemail.com>
	 <4F75D2A5.7060407@googlemail.com>
	 <20120403.180302.342779808900865443.davem@davemloft.net>
	 <1333491102.3040.12.camel@pasglop> <1335753820.20866.27.camel@pasglop>
	 <1335759088.20866.32.camel@pasglop> <4F9E1496.9060603@googlemail.com>
	 <1335760199.20866.33.camel@pasglop> <4F9E188E.80503@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> No idea, i was going by the old saying:
> "Thou shall not include kernel header, or you will feel the wrath of angry
> kernel gurus."

Heh :-)

Well, googling around, it looks like there's a mix of both type of
programs out there. Those using a struct bpf_program and those using a
struct soft_fprog.

Only the latter will work on BE machines as far as I can tell.

David, what's the right way to fix that ?

Cheers,
Ben.


