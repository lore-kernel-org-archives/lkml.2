Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab1JRPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:51:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:33886 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab1JRPvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:51:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,366,1315206000"; 
   d="scan'208";a="79289002"
From: Andi Kleen <andi@firstfloor.org>
To: p.herz@profihost.ag
Cc: linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
References: <4E9D53FF.7090609@profihost.ag>
Date: Tue, 18 Oct 2011 08:51:54 -0700
In-Reply-To: <4E9D53FF.7090609@profihost.ag> (Philipp Herz's message of "Tue,
	18 Oct 2011 12:25:03 +0200")
Message-ID: <m2ipnmz49x.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Herz - Profihost AG <p.herz@profihost.ag> writes:

> After updating kernel (x86_64) to stable version 3 there are a few
> messages appearing in the kernel log such as
>
> kworker/0:1: page allocation failure: order:1, mode:0x20
> mysql: page allocation failure: order:1, mode:0x20
> php5: page allocation failure: order:1, mode:0x20

You just ran out of memory.

The problem here seems to be that the kernel is unable to communicate
in a language you can understand. 

How do you think the message should have been phrased to make the 
issue more clear?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
