Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2E3SA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:00:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41086 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab2E3SAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:00:55 -0400
Message-ID: <4FC66037.6020506@zytor.com>
Date: Wed, 30 May 2012 11:00:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <20120530173247.GC15635@x1.osrc.amd.com> <4FC65D34.1060803@zytor.com> <20120530175150.GE15438@x1.osrc.amd.com>
In-Reply-To: <20120530175150.GE15438@x1.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 10:51 AM, Borislav Petkov wrote:
> On Wed, May 30, 2012 at 10:47:32AM -0700, H. Peter Anvin wrote:
>>> I wouldn't do that. Andre's patch switches to the
>>> rdmsrl_safe/checking_wrmsrl functions so you don't need to implement the
>>> _regs functions for pvops.
>>>
>> But we just stated - it is wrong for K8?
> 
> Not executed on K8 - only on F15h, models 0x10 - 0x1f.
> 

OK.  But there is still the general problem, no?

	-hpa

