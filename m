Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab0GKQVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 12:21:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:47986 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0GKQVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 12:21:13 -0400
Subject: Re: [PATCH 1/2] edac: mpc85xx: Fix MPC85xx dependency
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20100708045627.GA32489@oksana.dev.rtsoft.ru>
Date: Sun, 11 Jul 2010 11:20:57 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <D4D6F1B7-CCA0-49ED-8CDD-8F9385DDF03E@kernel.crashing.org>
References: <20100702124111.GA23320@oksana.dev.rtsoft.ru> <20100707144502.22b91374.akpm@linux-foundation.org> <20100708045627.GA32489@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <cbouatmailru@gmail.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 7, 2010, at 11:56 PM, Anton Vorontsov wrote:

> On Wed, Jul 07, 2010 at 02:45:02PM -0700, Andrew Morton wrote:
>> On Fri, 2 Jul 2010 16:41:11 +0400
>> Anton Vorontsov <avorontsov@mvista.com> wrote:
>> 
>>> Since commit 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx:
>>> Kconfig cleanup"), there is no MPC85xx Kconfig symbol anymore, so the
>>> driver became non-selectable.
>> 
>> hm.  5753c082f66eca5be81f6bda85c1718c5eea6ada got merged into mainline
>> six months ago.  How come nobody noticed?
> 
> Dunno. Well, it's hard to notice these sorts of things until
> somebody actually needs this driver on MPC85xx platform. :-)
> 
>>> This patch fixes the issue by switching to PPC_85xx symbol.
>>> 
>>> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
>>> ---
> [...]
>>> -	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
>>> +	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
>>> 	help
>>> 	  Support for error detection and correction on the Freescale
>>> 	  MPC8349, MPC8560, MPC8540, MPC8548
>> 
>> I suppose we shold scoot this into 2.6.35 and mark it for -stable
>> backporting.  All very odd.
> 
> Yeah, -stable 2.6.{33,34} sounds good.
> 
> Thanks.

we should add this to mpc85xx_defconfig so we build by default.

- k
