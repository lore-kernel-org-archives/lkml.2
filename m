Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0CXLLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:11:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39504 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0CXLLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:11:02 -0400
Date: Wed, 24 Mar 2010 12:10:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove early_res debug output (was Re: Confusing
 bootmem messages on bootup)
Message-ID: <20100324111046.GA15701@elte.hu>
References: <alpine.LNX.2.00.1003191526560.18642@pobox.suse.cz>
 <alpine.LNX.2.00.1003191544010.18642@pobox.suse.cz>
 <20100322082832.GB19077@elte.hu>
 <alpine.LNX.2.00.1003220931360.18642@pobox.suse.cz>
 <alpine.LNX.2.00.1003241155510.4242@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1003241155510.4242@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> Ingo,
> 
> are you going to pick this one up for -rc3 please?

Yeah - was on my list, have done that now. Andrew, any objections against 
this? (it touches mm/bootmem.c)

Thanks,

	Ingo
