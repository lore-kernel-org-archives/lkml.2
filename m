Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0FSJ2C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:28:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56622 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0FSJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:27:59 -0400
Date: Sat, 19 Jun 2010 11:27:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100619092758.GH18946@basil.fritz.box>
References: <1276697146.9309.27.camel@m0nster>
 <1276776066.2461.15.camel@localhost>
 <87vd9fo1sk.fsf@basil.nowhere.org>
 <4C1C8263.9040404@kernel.org>
 <87fx0jo0z6.fsf@basil.nowhere.org>
 <4C1C8772.8090406@kernel.org>
 <20100619090851.GF18946@basil.fritz.box>
 <4C1C8A18.2030709@kernel.org>
 <20100619091518.GG18946@basil.fritz.box>
 <4C1C8B32.1040007@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1C8B32.1040007@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm... yeah, adding it isn't hard.  I'm just a bit skeptical how
> useful it would be.  Having only single user would be a bit silly.

Why? If it's an important user...

> Can you think of anything else which could benefit from high priority
> queueing?

Over time we'll get more error handling, e.g. advanced NMI handling.
Maybe it could be useful for thermal handling too which is a similar
situation.

To be honest I would prefer if there aren't that many more users,
the more users the less useful it becomes.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
