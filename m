Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2CZFVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:21:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:23962 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab2CZFVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145324286"
Message-ID: <4F6FFCA3.3010000@intel.com>
Date: Mon, 26 Mar 2012 13:20:35 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: linux-next: manual merge of the akpm tree with the tip tree
References: <20120326150107.392bc3a7e0175b5009bcfeff@canb.auug.org.au>
In-Reply-To: <20120326150107.392bc3a7e0175b5009bcfeff@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 12:01 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the akpm tree got a conflict in  between
> commit a6fca40f1d7f ("x86, tlb: Switch cr3 in leave_mm() only when
> needed") from the tip tree and commit "x86: use this_cpu_xxx to replace
> percpu_xxx funcs" from the akpm tree.
>
> I fixed it up (see below) and can carry the fix as necessary.
Thanks!
