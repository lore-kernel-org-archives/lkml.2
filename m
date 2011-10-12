Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1JLCh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 22:37:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1JLCh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 22:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAHj3AVnRzOQEVJu6sfE-pZt9QN_q75Pf6LEeGfdKm-NdxjFC_Q@mail.gmail.com>
References: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
	<CAP2e6W9oQWLxe7pJxk=Awn1HTueeu41ZV7TFF+V9tHF07_Mxag@mail.gmail.com>
	<20111011161153.GA6697@suse.de>
	<CANK3SE1tdJm93BK+U01Ep7Q2B=+aUJmgxkrQ537oPrqB2YZ4nA@mail.gmail.com>
	<CAP2e6W9BCV5Wg5rTLrDLaU45NCt9PaSV5zZHT5OA88hqNvounw@mail.gmail.com>
	<CAHj3AVnRzOQEVJu6sfE-pZt9QN_q75Pf6LEeGfdKm-NdxjFC_Q@mail.gmail.com>
Date: Tue, 11 Oct 2011 19:37:55 -0700
Message-ID: <CAP2e6W-sSQP-5Xb_-38=j17pX8jJeTzuA2VCaCu3b6ERrCMQhw@mail.gmail.com>
Subject: Re: [PATCH 4/4] staging: et131x: Update TODO list
From: Ramesh R <rshlinux@gmail.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 11:40 AM, Denis Kirjanov <kirjanov@gmail.com> wrote:
> If you look at the patch once again then you find some
>
> On Tue, Oct 11, 2011 at 9:25 PM, Ramesh R <rshlinux@gmail.com> wrote:
>> Thanks Mark,
>>
>> Are there any open items left in the TODO list for this driver at this point?
>>
>> Regards
>> Ramesh
>>
>> On Tue, Oct 11, 2011 at 9:25 AM, Mark Einon <mark.einon@gmail.com> wrote:
>>> On 11 October 2011 17:11, Greg KH <gregkh@suse.de> wrote:
>>>> On Tue, Oct 11, 2011 at 09:00:35AM -0700, Ramesh R wrote:
>>>>> Hi Mark,
>>>>>
>>>>> I wish to contribute to this project - From the latest TODO list in
>>>>> the README document
>>>>>
>>>>> drivers/staging/et131x/README
>>>>>
>>>>> If I were to start with the coding style cleanups, is there a coding
>>>>> standard available for reference? Please advice.
>>>>
>>>> Documentation/CodingStyle
>>>>
>>> Ramesh,
>>>
>>> There are no significant coding style issues with this particular
>>> driver at this time, as far as I (and the checkpatch script) are aware
>>> of.
>>> I suggest you check other staging/ drivers for these sorts of issues.
>>>
>>> Cheers,
>>>
>>> Mark
>>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>>

Thank you, got a few items.

I could work on item #1,
==
 TODO:
+       - Put the driver into a single file, with a .h for the registers layout.
+       - rx_ring.fbr{0, 1} can probably share a common structure
+       - Use of kmem_cache seems a bit unusual
+       - Use dma_alloc_... in place of pci_alloc_...
+       - It's too late stopping the tx queue when there is no room
for the current packet. The condition should be detected for the next
packet.
+       - PCI_VDEVICE ?

==

I looked up for ET 1310 on ebay, amazon & few other sites like digikey
- I couldnt find the device. Can you please let me know where I can
buy the hardware?

/Ramesh
