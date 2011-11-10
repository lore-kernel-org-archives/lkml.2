Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1KJVtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:49:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44834 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1KJVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:49:45 -0500
Message-ID: <4EBC46FD.5010109@jp.fujitsu.com>
Date: Thu, 10 Nov 2011 16:49:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: nai.xia@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org,
        linux@arm.linux.org.uk
Subject: Re: mm: convert vma->vm_flags to 64bit
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>  <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com>  <4EBC085D.3060107@jp.fujitsu.com> <1320959579.21206.24.camel@pasglop>
In-Reply-To: <1320959579.21206.24.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 4:12 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2011-11-10 at 12:22 -0500, KOSAKI Motohiro wrote:
>> On 11/9/2011 11:09 PM, Nai Xia wrote:
>>> Hi all,
>>>
>>> Did this patch get merged at last, or on this way being merged, or
>>> just dropped ?
>>
>> Dropped.
>> Linus said he dislike 64bit enhancement.
> 
> Do you have a pointer ? (And a rationale)
> 
> I still want to put some arch flags in there at some point...

I'm sorry. I had got a machine crash awhile ago and I don't have
a past mail. If my remember is correctly, Linus said he worry about
an impact against 32bit x86 and he don't think current vm_flags
usage is enough efficient.

Maybe we need to ban useless arch specific flags at first.
