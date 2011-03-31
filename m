Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1CaCjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:39:12 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:63995 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1CaCjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:39:07 -0400
Date: Wed, 30 Mar 2011 22:38:47 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/4] x86: Minimize SRAT messages
In-reply-to: <20110301075128.GC12384@elte.hu>
Message-id: <alpine.LFD.2.02.1103302237200.1920@x980>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
 <20110225180634.422972243@gulag1.americas.sgi.com>
 <20110227120348.GE16453@elte.hu> <4D6BFA76.2060208@sgi.com>
 <20110301075128.GC12384@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

How about a patch to stuff the srat info into a debugfs file,
and another patch to delete the console printk entirely?

thanks,
Len Brown, Intel Open Source Technology Center

