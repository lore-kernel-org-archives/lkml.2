Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349Ab2EDWKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:10:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:34298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab2EDWKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:10:52 -0400
Message-ID: <1336169422.16236.1.camel@twins>
Subject: RE: [PATCH] sched: Enable arch-specific asym packing option in
 sched domain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Diwakar Tundlam <dtundlam@nvidia.com>
Cc: "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Michael Neuling'" <mikey@neuling.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Sat, 05 May 2012 00:10:22 +0200
In-Reply-To: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 15:06 -0700, Diwakar Tundlam wrote:
> +                               | arch_sd_sibling_asym_packing()        \
>                                 | sd_balance_for_package_power()        \
>                                 | sd_power_saving_flags()               \
>                                 ,                                       \ 

A repost doesn't make it right to add sibling (SMT) properties to a
package/socket and will still upset Power7.
