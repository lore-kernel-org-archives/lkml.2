Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0DOHq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:46:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:46659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0DOHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:46:55 -0400
Subject: Re: [PATCH 1/3] [kidled]: introduce kidled.
From: Peter Zijlstra <peterz@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
       arjan@infradead.org, csadler@google.com, ranjitm@google.com,
       kenchen@google.com, dawnchen@google.com
In-Reply-To: <o2y4352991a1004140841w7f37b84cnedcd91c2638a07ea@mail.gmail.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	 <20100414000823.29004.98991.stgit@bumblebee1.mtv.corp.google.com>
	 <87fx2y9xdn.fsf@basil.nowhere.org>
	 <o2y4352991a1004140841w7f37b84cnedcd91c2638a07ea@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 09:46:51 +0200
Message-ID: <1271317611.32749.68.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 08:41 -0700, Salman Qazi wrote:
> 
> To capture all the quantities for a CPU atomically, they must be read
> on the CPU.  Basically, reading them on that CPU prevents them from
> changing as we read them.
> 
> Also, if the CPU is idle (injected or otherwise), the quantities won't
> get updated. 

Who cares? by the time they reach userspace they've changed anyway.

