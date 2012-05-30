Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2E3RdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:33:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40605 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab2E3RdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:33:07 -0400
Message-ID: <4FC6597D.4060204@zytor.com>
Date: Wed, 30 May 2012 10:31:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jacob Shin <jacob.shin@amd.com>, Andre Przywara <andre.przywara@amd.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com>
In-Reply-To: <20120530171754.GA5115@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 10:17 AM, Konrad Rzeszutek Wilk wrote:
>> Yes, the following patch also fixed the crash for us:
>>
>> Implement rdmsr_regs and wrmsr_regs for Xen pvops.
> 
> That needs more data. Such as the reason for it, the crash
> tombstone, and an analysis of the bug.
> 
> But at this point I am not sure what we are going to do.
> 
> I think Peter leans towards ripping the .rdmsr_regs/wdmsr_regs
> function out altogether (so altering the amd_rdmsr... to use the
> .rdmsr/.wrdmsr). At which point I think this would all work
> just fine?
> 

No, you can't just do that.  Rip them out as in trap and emulate.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

