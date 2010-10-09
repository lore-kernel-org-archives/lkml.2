Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab0JITil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 15:38:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:34907 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab0JITik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 15:38:40 -0400
Message-ID: <4CB0C49A.7020900@suse.cz>
Date: Sat, 09 Oct 2010 21:38:02 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        aris@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
References: <20100901152130.GY2684@bombadil.infradead.org> <20100905061758.GA29547@merkur.ravnborg.org> <20100908115553.GC2617@sepie.suse.cz> <20101008143642.GA24144@bombadil.infradead.org> <4CAF30AE.3040305@suse.cz> <20101008151220.GB24144@bombadil.infradead.org>
In-Reply-To: <20101008151220.GB24144@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.10.2010 17:12, Kyle McMartin wrote:
> On Fri, Oct 08, 2010 at 04:54:38PM +0200, Michal Marek wrote:
>> Oh, sorry, I didn't realize that this is a regression from 2.6.35 and
>> applied it to the kconfig branch, which is part of for-next. I'll try to
>> send a pull request with this patch and two other later today, but I
>> don't know if Linus is going to accept it.
>>
> 
> It's not a regression from .35, just trying to avoid unexpected changes

Yeah, I meant "bug introduced in 2.6.36-rc1".


> to how parts of the build system work after release (which means it
> could be perceived as a regression from .36 to .37)
> 
> IE: Someone begins to expect this behaviour in 2.6.36, and then
>  the patch goes into 2.6.37-rc1, so 2.6.37 behaves differently.

I see.

Michal
