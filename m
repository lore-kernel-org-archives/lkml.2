Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab2EISIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:08:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44578 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2EISIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:08:47 -0400
Date: Wed, 9 May 2012 11:08:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 00/10] (no)bootmem bits for 3.5
Message-ID: <20120509180842.GG24636@google.com>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
 <20120507204113.GD10521@merkur.ravnborg.org>
 <20120507220142.GA1202@cmpxchg.org>
 <20120508175748.GA11906@merkur.ravnborg.org>
 <20120509173528.GD24636@google.com>
 <alpine.DEB.2.00.1205091252450.11225@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205091252450.11225@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Wed, May 09, 2012 at 12:54:37PM -0500, Christoph Lameter wrote:
> On some early 32 bit NUMA platforms only node 0 had ZONE_NORMAL memory.
> There is just no other ZONE_NORMAL memory available on other nodes on that
> hardware. But that is ancient history.

I see, but that shouldn't matter (at least anymore), the allocator can
fall back to other nodes just fine and there's no reason to
preemptively prefer node 0.

Thanks.

-- 
tejun
