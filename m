Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2F1KvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:51:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:53756 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2F1KvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:51:09 -0400
Message-ID: <1340880651.20977.83.camel@pasglop>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, scottwood@freescale.com,
        linux-kernel@vger.kernel.org, leoli@freescale.com
Date: Thu, 28 Jun 2012 20:50:51 +1000
In-Reply-To: <20120628033815.GA11387@localhost.localdomain>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
	 <1340748634.3732.27.camel@pasglop>
	 <20120627102138.GB10476@localhost.localdomain>
	 <1340797732.3732.46.camel@pasglop>
	 <20120628033815.GA11387@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 11:38 +0800, Zhao Chenhui wrote:
> 
> 
> The bootloader have done a timebase sync. If we do not need KEXEC or
> HOTPLUG_CPU feature, it is unnecessary to do it again at boot time of
> kernel. I only compile the timebase sync routines
> when users enable KEXEC or HOTPLUG_CPU. 

Still, how much are you really saving ? Is it worth the added mess and
loss of test coverage ?

We have too many conditional stuff like that already.

Cheers,
Ben.


