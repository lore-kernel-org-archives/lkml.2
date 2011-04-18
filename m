Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1DRXja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:39:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:12276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1DRXj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:39:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911352318"
Message-ID: <4DACCBB0.2060804@linux.intel.com>
Date: Mon, 18 Apr 2011 16:39:28 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@elte.hu, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] x86, cpu: Clean up and unify the NOP selection infrastructure
References: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>	 <1303166160-10315-3-git-send-email-hpa@linux.intel.com> <1303169476.7181.71.camel@gandalf.stny.rr.com>
In-Reply-To: <1303169476.7181.71.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 04:31 PM, Steven Rostedt wrote:
> 
> Can we please add a comment to this. The original (above) was confusing
> enough, but at least it used asm() so it wasn't that bad to figure out.
> Or at least the asm() usage would trigger in one's mind to think "Damn!
> They chose to use 'asm', it must be some kind of nasty trick. Let's take
> a better look at WTF they are doing!".
> 
> Now the use a normal character array actual makes this even more subtle.

OK... I never thought it was particularly subtle, but okay.

A much bigger issue with this particular patch is that the
__init{data,const}_or_module presumably needs to be removed from these
structures, right?

	-hpa
