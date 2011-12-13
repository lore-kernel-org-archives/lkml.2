Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1LMUGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:06:42 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:25500 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab1LMUGk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:06:40 -0500
From: Bhavesh Davda <bhavesh@vmware.com>
To: Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@vmware.com>
CC: Andrei Warkentin <awarkentin@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Tue, 13 Dec 2011 12:06:54 -0800
Subject: RE: [Pv-drivers] [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Thread-Topic: [Pv-drivers] [PATCH] include/log2.h: Fix
 rounddown_pow_of_two(1)
Thread-Index: Acy50gHlA1t+HwvHQlWVLK0EYvbSxwAAGaHw
Message-ID: <B07832953588294D802727FF264E276A13EC9D4B22@exch-mbx-112.vmware.com>
References: <1323712953-13636-1-git-send-email-dtor@vmware.com>
 <1323806421.9082.53.camel@twins>
In-Reply-To: <1323806421.9082.53.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2011-12-12 at 10:02 -0800, Dmitry Torokhov wrote:
> > 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1.
> 
> x^0 = 1
> x^1 = x
> 
> Seems to me 0 was the right answer, no?

Eh? The answer should be the power-of-two (1), not the exponent (0).
