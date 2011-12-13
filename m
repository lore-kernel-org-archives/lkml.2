Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1LMUID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:08:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:39623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1LMUIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:08:01 -0500
Message-ID: <1323806832.28489.1.camel@twins>
Subject: RE: [Pv-drivers] [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
From: Peter Zijlstra <peterz@infradead.org>
To: Bhavesh Davda <bhavesh@vmware.com>
Cc: Dmitry Torokhov <dtor@vmware.com>,
        Andrei Warkentin <awarkentin@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Tue, 13 Dec 2011 21:07:12 +0100
In-Reply-To: <B07832953588294D802727FF264E276A13EC9D4B22@exch-mbx-112.vmware.com>
References: <1323712953-13636-1-git-send-email-dtor@vmware.com>
	 <1323806421.9082.53.camel@twins>
	 <B07832953588294D802727FF264E276A13EC9D4B22@exch-mbx-112.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 12:06 -0800, Bhavesh Davda wrote:
> > On Mon, 2011-12-12 at 10:02 -0800, Dmitry Torokhov wrote:
> > > 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1.
> > 
> > x^0 = 1
> > x^1 = x
> > 
> > Seems to me 0 was the right answer, no?
> 
> Eh? The answer should be the power-of-two (1), not the exponent (0).

Yeah, just noticed that, see my other reply.
