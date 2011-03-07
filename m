Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1CGDBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:01:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:58474 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab1CGDBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:01:52 -0500
Subject: Re: [PATCH] mm/memblock: Properly handle overlaps and fix error
 path
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>
In-Reply-To: <4D741890.7000607@kernel.org>
References: <1299453678.8833.969.camel@pasglop>
	 <4D741890.7000607@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 14:01:13 +1100
Message-ID: <1299466873.8833.971.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 15:28 -0800, Yinghai Lu wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Mon, 7 Mar 2011 10:18:38 +1100
> > Subject: 
> 
> you put two patches in one mail?

Odd... must have inadvertently poked the middle button, let me resend.

Cheers,
Ben.


