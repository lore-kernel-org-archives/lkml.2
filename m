Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1DTKIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:08:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:33382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1DTKIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:08:10 -0400
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
In-Reply-To: <1299766211.2308.4468.camel@twins>
References: <1299639487.22236.256.camel@pasglop>
	 <1299665998.2308.2753.camel@twins>  <1299675674.2308.2924.camel@twins>
	 <1299766211.2308.4468.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Apr 2011 12:07:36 +0200
Message-ID: <1303294056.8345.122.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 15:10 +0100, Peter Zijlstra wrote:
> 
> Also, still waiting to hear from the Power7 folks on how often they
> think to rebuild the topology and how they think that makes sense,
> afaict Power7 does have actual NUMA nodes unlike s390, so I'm still not
> seeing how that's going to work properly at all. 

Jesse care to answer? I hear from Ben you're responsible for that mess.
