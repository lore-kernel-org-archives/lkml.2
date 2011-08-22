Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab1HVO2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:28:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab1HVO2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:28:31 -0400
Subject: Re: [RFC][PATCH 6/6] x86, nmi: print out NMI stats in
 /proc/interrupts
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Date: Mon, 22 Aug 2011 16:27:42 +0200
In-Reply-To: <1313786266-9585-7-git-send-email-dzickus@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
	 <1313786266-9585-7-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314023262.24275.38.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> NMI:       4161       4155        158       4194   Non-maskable interrupts
> SWA:          0          0          0          0   Unknown NMIs swallowed
>   0:       4161       4155        158       4194   NMI  PMI, arch_bt
> UNK:          0          0          0          0   NMI
> EXT:          0          0          0          0   NMI 

Yeah, not too pretty.. I would have expected something like:

NMI:
 PMI:
 uv:
 arch_bt:
 ...
 swallowed:
 unknown:

But then, I'm sure some people would complain to that as I'm pretty sure
it'll break stuff parsing /proc/interrupts
