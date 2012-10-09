Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2JIGZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:25:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:5297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab2JIGZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:25:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,558,1344236400"; 
   d="scan'208";a="223947757"
Message-ID: <5073C357.6080805@zytor.com>
Date: Tue, 09 Oct 2012 14:25:27 +0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org> <5073BF32.7040003@zytor.com> <CAE9FiQWUg0wmMLANmshxob3ftxa2xY9mUSivzsWCGkJ2_==_Qg@mail.gmail.com>
In-Reply-To: <CAE9FiQWUg0wmMLANmshxob3ftxa2xY9mUSivzsWCGkJ2_==_Qg@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 02:21 PM, Yinghai Lu wrote:
>>
>> Hi Yinghai,
>>
>> This patchset doesn't apply on top of tip:x86/mm2, starting at patch 08/10.
> 
> sorry for that. I refresh my base to current linus/master and tip/master.
> 
> could be some change there.
> 
> could solve it:
> 1. update x86/mm2 to linus/master
> 2. or i resend the patch again with x86/mm2 as base.
> 
> please let me know which one you like.
> 

If it doesn't have cross-dependencies on other code, x86/mm2 is probably
the best base; if there are other dependencies then that's fine, but we
need to know what they are.  We don't want to create unnecessary tangles
among topic branches, it makes Linus very unhappy.

	-hpa

