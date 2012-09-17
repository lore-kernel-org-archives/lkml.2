Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2IQTLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:11:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42391 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2IQTLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:11:06 -0400
Date: Mon, 17 Sep 2012 21:11:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] x86, fpu: decouple non-lazy/eager fpu restore
 from xsave
Message-ID: <20120917191107.GA30665@elf.ucw.cz>
References: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
 <1347300665-6209-2-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347300665-6209-2-git-send-email-suresh.b.siddha@intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

irely omitted.
>  			and restore using xsave. The kernel will fallback to
>  			enabling legacy floating-point and sse state.
>  
> +	eagerfpu=	[X86]
> +			on	enable eager fpu restore
> +			off	disable eager fpu restore
> +

Hmm. Only useful piece of information here is that this is about FPU
_restore_. Otherwise it tells the user exactly nothing.

Why would user want to enable it? Disable it? What is the default?

    	       	       	      	  	      	      	  Pavel 
