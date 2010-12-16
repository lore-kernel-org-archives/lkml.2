Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab0LPJZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:25:21 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47716 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0LPJZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:25:18 -0500
Subject: Re: [PATCH -mm -v8 0/3] Lockless memory allocator and list
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1292482744-12953-1-git-send-email-ying.huang@intel.com>
References: <1292482744-12953-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 10:24:27 +0100
Message-ID: <1292491467.6803.4327.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 14:59 +0800, Huang Ying wrote:
> This patchset adds a lockless memory allocator and a lock-less
> list.

Still no users the allocator, and no attempt to unify the existing
lockless list implementations.

I'm getting very tired of this Huang.
