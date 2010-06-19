Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0FSMUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:20:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0FSMUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:20:16 -0400
Date: Sat, 19 Jun 2010 14:20:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100619122010.GI18946@basil.fritz.box>
References: <87vd9fo1sk.fsf@basil.nowhere.org>
 <4C1C8263.9040404@kernel.org>
 <87fx0jo0z6.fsf@basil.nowhere.org>
 <4C1C8772.8090406@kernel.org>
 <20100619090851.GF18946@basil.fritz.box>
 <4C1C8A18.2030709@kernel.org>
 <20100619091518.GG18946@basil.fritz.box>
 <4C1C8B32.1040007@kernel.org>
 <20100619092758.GH18946@basil.fritz.box>
 <4C1C911B.6040601@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1C911B.6040601@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Do machines ever report that many MCE errors?  The usual rate seems
>   like one per weeks or months even when they're frequent.

Yes you can even get a flood when the system or parts 
of the system is dying. There's some throttling in the error handling, 
but yes in some cases you can get high rates.

> * If a machine is actually reporting enough errors to overwhelm single
>   error handling thread, does it even matter what we do?

There are cases where you can have many errors but still survive.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
