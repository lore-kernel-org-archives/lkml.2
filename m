Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2CVOz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:55:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55333 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2CVOzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:55:53 -0400
Message-ID: <1332428124.2487.15.camel@twins>
Subject: Re: [PATCH 0/4] arch/CPU hotplug: Add missing CPU Hotplug bits to
 fix nasty issues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, rkuo@codeaurora.org,
        tglx@linutronix.de, linas@codeaurora.org, mingo@elte.hu,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        akpm@linux-foundation.org, benh@kernel.crashing.org,
        jesper.nilsson@axis.com, cmetcalf@tilera.com, linux@arm.linux.org.uk,
        jejb@parisc-linux.org, deller@gmx.de, vapier@gentoo.org,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org
Date: Thu, 22 Mar 2012 15:55:24 +0100
In-Reply-To: <1332427989.2946.20.camel@dabdike.int.hansenpartnership.com>
References: <20120322112735.17063.21791.stgit@srivatsabhat.in.ibm.com>
	 <1332418412.2487.13.camel@twins>
	 <1332427989.2946.20.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 14:53 +0000, James Bottomley wrote:
> parisc actually uses cpu hotplug to boot its secondary cpus. 

I think we all do these days..
