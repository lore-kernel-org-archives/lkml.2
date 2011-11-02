Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab1KBCm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:42:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42353 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab1KBCmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:42:25 -0400
Message-ID: <4EB0AE0E.8040709@vflare.org>
Date: Tue, 01 Nov 2011 22:42:22 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        gregkh@suse.de, devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org> <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org> <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org> <4E72284B.2040907@linux.vnet.ibm.com> <4E738B81.2070005@vflare.org 1320168615.15403.80.camel@nimitz> <e51b28f7-da4a-4c53-889d-4f12b8dd701a@default>
In-Reply-To: <e51b28f7-da4a-4c53-889d-4f12b8dd701a@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 02:35 PM, Dan Magenheimer wrote:

>> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
>> Sent: Tuesday, November 01, 2011 11:30 AM
>> To: Nitin Gupta
>> Cc: Seth Jennings; Greg KH; gregkh@suse.de; devel@driverdev.osuosl.org; Dan Magenheimer;
>> cascardo@holoscopio.com; linux-kernel@vger.kernel.org; linux-mm@kvack.org; brking@linux.vnet.ibm.com;
>> rcj@linux.vnet.ibm.com
>> Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
>>
>> On Fri, 2011-09-16 at 13:46 -0400, Nitin Gupta wrote:
>>> I think replacing allocator every few weeks isn't a good idea. So, I
>>> guess better would be to let me work for about 2 weeks and try the slab
>>> based approach.  If nothing works out in this time, then maybe xcfmalloc
>>> can be integrated after further testing.
>>
>> Hi Nitin,
>>
>> It's been about six weeks. :)
>>
>> Can we talk about putting xcfmalloc() in staging now?
> 
> FWIW, given that I am quoting "code rules!" to the gods of Linux
> on another lkml thread, I can hardly disagree here.
> 


I agree with you Dan. It took me really long to bring the new allocator
into some shape and still I'm not very confident that it's ready to be
integrated with zcache.

> If Nitin continues to develop his allocator and it proves
> better than xcfmalloc (and especially if it can replace
> zbud as well), we can consider replacing xcfmalloc later.
> Until zcache is promoted from staging, I think we have
> that flexibility.
> 


Agreed.  Though I still consider slab based design much better, having
already tried xcfmalloc like design much earlier in the project history,
I would still favor xcfmalloc integration since xvmalloc weakness with
>PAGE_SIZE/2 objects is probably too much to bear.


> (Shameless advertisement though:  The xcfmalloc allocator
> only applies to pages passed via frontswap, and on
> that other lkml thread lurk many people intent on shooting
> frontswap down.  So, frankly, I'd prefer time to be spent
> on benchmarking zcache rather than on arguing about
> allocators which, as things currently feel to me on that
> other lkml thread, is not unlike rearranging deck chairs
> on the Titanic. Half-:-).
> 
>


Thanks,
Nitin

