Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab1ECBtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:49:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:54677 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1ECBtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:49:49 -0400
Subject: Re: [PATCH 1/6] powerpc: stop exporting irq_map
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20110428200148.8979.66709.stgit@ponder>
References: <20110428192227.8979.49181.stgit@ponder>
	 <20110428200148.8979.66709.stgit@ponder>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 11:44:21 +1000
Message-ID: <1304387061.2513.294.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 14:01 -0600, Grant Likely wrote:
> First step in eliminating irq_map[] table entirely
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  

Ack in principle, needs scrutiny and testing of course :-)

Cheers,
Ben.



