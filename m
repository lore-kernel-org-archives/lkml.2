Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1BTVyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:54:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6975 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1BTVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=E7DDKVe33BUkV++Vg73woDOxPJtanG87BPuRJQowxQcoOQMmZJmiPW2Gq8B5/NL43C
         pifPq1X+TJWXfyIFeVBg==
Date: Sun, 20 Feb 2011 13:54:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 0/5] fix up /proc/$pid/smaps to not split huge pages
In-Reply-To: <20110209212404.GR3347@random.random>
Message-ID: <alpine.DEB.2.00.1102201352570.26991@chino.kir.corp.google.com>
References: <20110209195406.B9F23C9F@kernel> <20110209212404.GR3347@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011, Andrea Arcangeli wrote:

> On Wed, Feb 09, 2011 at 11:54:06AM -0800, Dave Hansen wrote:
> > Andrea, after playing with this for a week or two, I'm quite a bit
> > more confident that it's not causing much harm.  Seems a fairly
> > low-risk feature.  Could we stick these somewhere so they'll at
> > least hit linux-next for the 2.6.40 cycle perhaps?
> 
> I think they're good to go in mmotm already and to be merged ASAP.
> 
> The only minor issue I have is the increment, to become per-cpu. Are
> we going to change its location then or it's still read through sysfs?
> 

Dave, I notice these patches haven't been merged into -mm yet.  Are we 
waiting on another iteration or is this set ready to go?
