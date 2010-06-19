Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0FSIzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:55:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36653 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0FSIzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:55:43 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	<1276776066.2461.15.camel@localhost>
	<87vd9fo1sk.fsf@basil.nowhere.org> <4C1C8263.9040404@kernel.org>
Date: Sat, 19 Jun 2010 10:55:41 +0200
In-Reply-To: <4C1C8263.9040404@kernel.org> (Tejun Heo's message of "Sat, 19
	Jun 2010 10:40:03 +0200")
Message-ID: <87fx0jo0z6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
>
> Wouldn't that be better served by cpu_stop?

No the error handling has to be able to sleep to take VM
locks. That's the whole point its handed off to a
workqueue. Otherwise it could be done directly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
