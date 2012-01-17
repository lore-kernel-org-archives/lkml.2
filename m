Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2AQSvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:51:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57602 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754969Ab2AQSvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:51:16 -0500
Message-ID: <1326826273.17202.11.camel@joe2Laptop>
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: mirq-linux@rere.qmqm.pl, linux-kernel@vger.kernel.org
Date: Tue, 17 Jan 2012 10:51:13 -0800
In-Reply-To: <20120117.134640.1673981737109339596.davem@davemloft.net>
References: <1326825433.17202.6.camel@joe2Laptop>
	 <20120117.134640.1673981737109339596.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 13:46 -0500, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Tue, 17 Jan 2012 10:37:13 -0800
> > Passing NULL to %pNF is done in skb_gso_segment
> > which could be dereferenced.
> skb_gso_segment() should be fixed instead.

Maybe.  Dereferencing NULL is bad form.
Michał Mirosław should fix that as it's his patch.

noinline_for_stack should be added anyway.


