Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2EYHbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:31:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:37039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2EYHbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:31:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="147674822"
Message-ID: <4FBF3561.4040805@linux.intel.com>
Date: Fri, 25 May 2012 15:31:45 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <20120525062426.GB3179@aftab.osrc.amd.com>
In-Reply-To: <20120525062426.GB3179@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/5/25 14:24, Borislav Petkov 写道:
> On Thu, May 24, 2012 at 05:54:52PM +0000, Thomas Gleixner wrote:
>> Intentionally left blank to be filled out by someone who wants
>> that and can explain the reason for this better than me.
> 
> That'll be Intel folk :)
> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Looks good to me too, thanks Thomas for doing this!
> 
> I'll run it next week just in case.
> 
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> 

Oh, Oh, wait. First I need to thank Thomas to improve it. I don't
reply you at the first time because I have some thoughts and now
I'm testing it. The basic test shows it hangs the system after
sb_edac is removed and when error count increases to the threshold
it hangs again, and when trying to reboot the system no hang happnes
(not reach the threshold) the system oops. I need to time to debug
and give the valid feedback. Please be patient :-). Of course,
I still need time to add some description for Thomas ;-)

