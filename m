Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0FDBnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:43:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33859 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab0FDBnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:43:46 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Fri, 4 Jun 2010 09:43:31 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1275479804.137633.565764505843.0.gpush@pororo> <20100603110533.GB7127@n2100.arm.linux.org.uk> <20100604000605.GF4720@trinity.fluff.org>
In-Reply-To: <20100604000605.GF4720@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006040943.32527.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> As an addendum to Russell's comments, we need to specify the behaviour
> with resepect to what happens about clock stabilisation as well, if the
> clock we enabled takes time to stabilise, then should we wait?

Yes. If we're going to the effort of ensuring that the clock is enabled before 
clk_enable returns, we should also guarantee that the clock is fully-
functional.

If that takes some time, then that's just the cost of ensuring correct 
behaviour.

Cheers,


Jeremy
