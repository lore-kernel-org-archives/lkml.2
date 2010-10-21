Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab0JUVkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:40:06 -0400
Received: from claw.goop.org ([74.207.240.146]:39867 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0JUVkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:40:03 -0400
Message-ID: <4CC0B32C.8000503@goop.org>
Date: Thu, 21 Oct 2010 14:39:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] linux-next: build warning after merge of the final
 tree (xen tree related)
References: <20101021145326.9f133f40.sfr@canb.auug.org.au>
In-Reply-To: <20101021145326.9f133f40.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/20/2010 08:53 PM, Stephen Rothwell wrote:
> Hi Jeremy,
>
> After merging the final tree, today's linux-next build (i386 defconfig)
> produced this warning:
>
> arch/x86/mm/fault.c: In function 'vmalloc_sync_all':
> arch/x86/mm/fault.c:244: warning: assignment makes integer from pointer without a cast
>
> Introduced by commit aef8b70e5c4b7753fc4bf20dbb01e93fc8883027 ("x86: hold
> mm->page_table_lock while doing vmalloc_sync").

This change got merged into tip/master, and it looks like there's
already a fix there for this warning.  I've dropped it from my branch.

Thanks,
    J
