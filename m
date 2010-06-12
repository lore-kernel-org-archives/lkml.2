Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0FLFLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:11:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:55261 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0FLFLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:11:15 -0400
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
In-Reply-To: <19473.61547.684572.647641@ipc1.ka-ro>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	 <1275636608.607067.417709988883.1.gpush@pororo>
	 <20100611042046.GA31045@fluff.org.uk>
	 <201006111557.12249.jeremy.kerr@canonical.com>
	 <19473.61547.684572.647641@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 15:10:49 +1000
Message-ID: <1276319449.1962.178.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> makes it impossible to call those functions in interrupt context.

And doing clk_enable/clk_disable from interrupt context is a bad idea as
well :-)

Cheers,
Ben.


