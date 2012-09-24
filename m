Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2IXUvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:51:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:10038 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab2IXUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:51:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,477,1344236400"; 
   d="scan'208";a="196536165"
Message-ID: <5060C7E8.2060500@linux.intel.com>
Date: Mon, 24 Sep 2012 13:51:52 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linda Wang <lwang@redhat.com>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 00/11] x86: Supervisor Mode Access Prevention
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com> <20120921220818.GA30959@redhat.com> <505CE5C8.80007@linux.intel.com> <20120922113226.GA3257@gmail.com> <5060C330.1000407@zytor.com> <CAGXu5jJraZJc2nYZUEDeroa9qwy_sN9kvFYAJvdubQ_wky25zw@mail.gmail.com>
In-Reply-To: <CAGXu5jJraZJc2nYZUEDeroa9qwy_sN9kvFYAJvdubQ_wky25zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 01:43 PM, Kees Cook wrote:
> 
> How about this...
> 
> mem protection  : nx smap smep
> 
> Maybe the "why" of a cpu feature being missing from the "mem
> protection" line can stay in printk?
> 

Come to think about it, since we use setup_set/clear_cpu_cap we aready
don't list the feature in /proc/cpuinfo already if it isn't enabled.

I would therefore suggest that we simply printk a message if the feature
is disabled.

	-hpa
