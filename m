Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab0JUVen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:34:43 -0400
Received: from claw.goop.org ([74.207.240.146]:34635 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0JUVem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:34:42 -0400
Message-ID: <4CC0B1ED.4050607@goop.org>
Date: Thu, 21 Oct 2010 14:34:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
References: <4CB76E8B.2090309@goop.org> <4CC0AB73.8060609@goop.org> <4CC0B006.7040008@zytor.com>
In-Reply-To: <4CC0B006.7040008@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/21/2010 02:26 PM, H. Peter Anvin wrote:
> On 10/21/2010 02:06 PM, Jeremy Fitzhardinge wrote:
>>  Ping?  Have you had any thoughts about possible x86-64 problems with this?
>>
>> Thanks,
>>     J
> I didn't find any, so I already committed your patch to tip:x86/mm two
> days ago.

Oh, thanks!  I didn't see the tip commit.

> Now, it's worth noting that Linus has asked us to get rid of
> vmalloc_sync_all() completely, which would be a good thing in the longer
> term.

Fine by me.

    J
