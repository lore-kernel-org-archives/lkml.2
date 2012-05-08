Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2EHUPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:15:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab2EHUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:15:30 -0400
Message-ID: <4FA97ED3.1060105@intel.com>
Date: Tue, 08 May 2012 13:15:15 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>
Subject: Re: [PATCH 02/23] x86, realmode: realmode.bin infrastructure
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-3-git-send-email-jarkko.sakkinen@intel.com> <20120508185349.GA12013@merkur.ravnborg.org> <4FA9709F.6020700@linux.intel.com>
In-Reply-To: <4FA9709F.6020700@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 12:14 PM, H. Peter Anvin wrote:
>>
>> How much is needed to avoid this misuse of kernel-internal build rules?
>> This was and is an ugly hack.
>>
> 
> It is more or less the same as for arch/x86/boot and other things.  If
> there are better ways to do it suggestions are very much appreciated.
> 
> However, it is a bit of a tricky bit because we need *some* of the bits
> of the target compiler configuration and some not (this is the same as
> arch/x86/boot etc.)  It is not "pure target" but it's also most
> definitely not host.
> 

Anyway... to answer your direct question: all of that would have been
required anyway.  In therms of build rules the overall patchset is
pretty much a lateral move from arch/x86/kernel/acpi/rm to
arch/x86/realmode/rm.  That doesn't mean we couldn't do it
better/centralize/etc; however, none of this is new and would be a
separate change.

	-hpa

