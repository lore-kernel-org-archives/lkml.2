Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab0JHOym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:54:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:54833 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758316Ab0JHOyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:54:41 -0400
Message-ID: <4CAF30AE.3040305@suse.cz>
Date: Fri, 08 Oct 2010 16:54:38 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        aris@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
References: <20100901152130.GY2684@bombadil.infradead.org> <20100905061758.GA29547@merkur.ravnborg.org> <20100908115553.GC2617@sepie.suse.cz> <20101008143642.GA24144@bombadil.infradead.org>
In-Reply-To: <20101008143642.GA24144@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.10.2010 16:36, Kyle McMartin wrote:
> On Wed, Sep 08, 2010 at 01:55:53PM +0200, Michal Marek wrote:
>> I found that when running make oldnoconfig on the kconfig branch of
>> kbuild.git (which is currently a 2.6.35 + kconfig changes) against a
>> 2.6.35-rc1 x86_64 defconfig, it mysteriously switches from
>> CONFIG_KERNEL_GZIP=y to CONFIG_KERNEL_LZO=y. With Kyle's patch it
>> doesn't do this. I applied the patch now.
>>
> 
> Hi Michal,
> 
> Can we get this sent to Linus before 2.6.36? It would be awkward to
> release 2.6.36 with oldnoconfig working the broken way, and then patch
> it after release.

Oh, sorry, I didn't realize that this is a regression from 2.6.35 and
applied it to the kconfig branch, which is part of for-next. I'll try to
send a pull request with this patch and two other later today, but I
don't know if Linus is going to accept it.

Michal
