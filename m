Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab2IUWKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:10:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:21566 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984Ab2IUWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:10:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225257225"
Message-ID: <505CE5C8.80007@linux.intel.com>
Date: Fri, 21 Sep 2012 15:10:16 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <20120921220818.GA30959@redhat.com>
In-Reply-To: <20120921220818.GA30959@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 03:08 PM, Dave Jones wrote:
> 
> Perhaps add a printk somewhere to show that it's actually been enabled maybe ?
> 
> Also, would it be feasible to add something like we have for test_nx ?
> If this feature regresses in some way in the future, I suspect we'd like
> to know about it sooner rather than later.
> 

Good idea... should add this both for SMEP and SMAP.

	-hpa



