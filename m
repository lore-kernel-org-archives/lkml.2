Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2CXXuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 19:50:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:42827 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2CXXub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 19:50:31 -0400
Message-ID: <1332633000.2882.15.camel@pasglop>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Date: Sun, 25 Mar 2012 10:50:00 +1100
In-Reply-To: <4F6DDE56.3090401@openvz.org>
References: <20120321065140.13852.52315.stgit@zurg>
	 <20120321100602.GA5522@barrios> <4F69D496.2040509@openvz.org>
	 <20120322053958.GA5278@barrios> <1332397358.2982.82.camel@pasglop>
	 <4F6DDE56.3090401@openvz.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 18:46 +0400, Konstantin Khlebnikov wrote:
> Obviously we can combine VM_PFN_AT_MMAP, VM_SAO, VM_GROWSUP and
> VM_MAPPED_COPY into one.

VM_PFN_AT_MMAP isn't arch specific afaik...

Cheers,
Ben.


