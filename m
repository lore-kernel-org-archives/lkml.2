Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0CXORv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:17:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340Ab0CXORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:17:50 -0400
Date: Wed, 24 Mar 2010 07:16:03 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] x86: remove early_res debug output (was Re: Confusing
 bootmem messages on bootup)
Message-Id: <20100324071603.fc117b39.akpm@linux-foundation.org>
In-Reply-To: <20100324111046.GA15701@elte.hu>
References: <alpine.LNX.2.00.1003191526560.18642@pobox.suse.cz>
	<alpine.LNX.2.00.1003191544010.18642@pobox.suse.cz>
	<20100322082832.GB19077@elte.hu>
	<alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
	<alpine.LNX.2.00.1003241155510.4242@pobox.suse.cz>
	<20100324111046.GA15701@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 12:10:46 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > Ingo,
> > 
> > are you going to pick this one up for -rc3 please?
> 
> Yeah - was on my list, have done that now. Andrew, any objections against 
> this? (it touches mm/bootmem.c)
> 

OK by me.  Johannes has been doing the bootmem work lately, so please
cc him on changes..

