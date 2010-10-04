Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0JDOpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:45:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38714 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab0JDOpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:45:21 -0400
Message-ID: <4CA9E87A.3000807@austin.ibm.com>
Date: Mon, 04 Oct 2010 09:45:14 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Dave Hansen <dave@linux.vnet.ibm.com>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, steiner@sgi.com
Subject: Re: [PATCH 7/9] v3 Define memory_block_size_bytes for powerpc/pseries
References: <4CA62700.7010809@austin.ibm.com> <4CA62A0A.4050406@austin.ibm.com> <20101003175500.GE7896@balbir.in.ibm.com> <20101003180731.GT14064@sgi.com> <1286129461.9970.1.camel@nimitz> <20101003182701.GI7896@balbir.in.ibm.com>
In-Reply-To: <20101003182701.GI7896@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2010 01:27 PM, Balbir Singh wrote:
> * Dave Hansen <dave@linux.vnet.ibm.com> [2010-10-03 11:11:01]:
> 
>> On Sun, 2010-10-03 at 13:07 -0500, Robin Holt wrote:
>>> On Sun, Oct 03, 2010 at 11:25:00PM +0530, Balbir Singh wrote:
>>>> * Nathan Fontenot <nfont@austin.ibm.com> [2010-10-01 13:35:54]:
>>>>
>>>>> Define a version of memory_block_size_bytes() for powerpc/pseries such that
>>>>> a memory block spans an entire lmb.
>>>>
>>>> I hope I am not missing anything obvious, but why not just call it
>>>> lmb_size, why do we need memblock_size?
>>>>
>>>> Is lmb_size == memblock_size after your changes true for all
>>>> platforms?
>>>
>>> What is an lmb?  I don't recall anything like lmb being referred to in
>>> the rest of the kernel.
>>
>> Heh.  It's the OpenFirmware name for a Logical Memory Block.  Basically
>> what we use to determine the SECTION_SIZE on powerpc.  Probably not the
>> best terminology to use elsewhere in the kernel.
> 
> Agreed for the kernel, this patch was for powerpc/pseries, hence was
> checking in this context.
> 

I don't really see a reason to name it lmb_size, it seems easier
to stick with the naming used by the rest of the kernel.

-Nathan
