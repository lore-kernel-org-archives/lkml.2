Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2E1XN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 19:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab2E1XN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 19:13:27 -0400
Message-ID: <4FC4068B.6000903@redhat.com>
Date: Mon, 28 May 2012 20:13:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC v26 00/66] EDAC patches for v3.5
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com> <20120518164615.GY20215@aftab.osrc.amd.com> <4FB68A28.9090205@redhat.com> <20120518175336.GB20215@aftab.osrc.amd.com> <4FC39DB8.7080804@redhat.com> <20120528203655.GA25058@aftab.osrc.amd.com>
In-Reply-To: <20120528203655.GA25058@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-05-2012 17:36, Borislav Petkov escreveu:
> On Mon, May 28, 2012 at 12:46:00PM -0300, Mauro Carvalho Chehab wrote:
>> Em 18-05-2012 14:53, Borislav Petkov escreveu:
>>> On Fri, May 18, 2012 at 02:43:04PM -0300, Mauro Carvalho Chehab wrote:
>>>>>>   RAS: Add a tracepoint for reporting memory controller events
>>>>>
>>>>> Are you kidding me?
>>>>>
>>>>> You want to send patches upstream which are still in review and 
>>>>
>>>> No, I want to post the last version of the patches and provide a
>>>> clearer description of what this patch series do, before sending the
>>>> git pull request when the merge window opens.
>>>
>>> I'm fine with offloading some of your stuff which has been reviewed
>>> and agreed upon but pushing in stuff into the merge window (it should
>>> open over the weekend, my clairvoyant skills tell me) which is still in
>>> review is a no-no.
>>
>> I'll do a pull request for the patches that were already reviewed/discussed,
>> e. g:
>>
>> 59148b4 RAS: Add a tracepoint for reporting memory controller events
> 
> This one is not finished yet, sorry, I was away and I couldn't reply -
> will reply to your last email about it tomorrow.

Hmm... all requested issues were already addressed. What else do you want?

Anyway, I'll keep this out of the tomorrow's pull request, in order to wait 
for your comments.

> 
> The rest should be fine.
> 
>> 4c63e95 i5400_edac: improve debug messages to better represent the filled memory
>> 56435f4 edac: Cleanup the logs for i7core and sb edac drivers
>> f7bd747 edac: Initialize the dimm label with the known information
>> d24e447 edac: Remove the legacy EDAC ABI
>> 954d5f6 x38_edac: convert driver to use the new edac ABI
>> 8e96c92 tile_edac: convert driver to use the new edac ABI
>> c08c7fc sb_edac: convert driver to use the new edac ABI
>> 02dc07b r82600_edac: convert driver to use the new edac ABI
>> 6ecaee8 ppc4xx_edac: convert driver to use the new edac ABI
>> 7e2f423 pasemi_edac: convert driver to use the new edac ABI
>> 73f6e30 mv64x60_edac: convert driver to use the new edac ABI
>> caad9cf mpc85xx_edac: convert driver to use the new edac ABI
>> bc7c482 i82975x_edac: convert driver to use the new edac ABI
>> 2f782de i82875p_edac: convert driver to use the new edac ABI
>> cd65cb3 i82860_edac: convert driver to use the new edac ABI
>> 3340fb0 i82443bxgx_edac: convert driver to use the new edac ABI
>> 8e9c3a2 i7core_edac: convert driver to use the new edac ABI
>> 1881dd2 i7300_edac: convert driver to use the new edac ABI
>> 462ad2d i5400_edac: convert driver to use the new edac ABI
>> ed2f23e i5100_edac: convert driver to use the new edac ABI
>> 7c27069 i5000_edac: convert driver to use the new edac ABI
>> 6b4cacb i3200_edac: convert driver to use the new edac ABI
>> 0615f9d i3000_edac: convert driver to use the new edac ABI
>> 232e77b e7xxx_edac: convert driver to use the new edac ABI
>> 0b58240 e752x_edac: convert driver to use the new edac ABI
>> c9f3f84 cpc925_edac: convert driver to use the new edac ABI
>> 7fe894e cell_edac: convert driver to use the new edac ABI
>> 4d38c9c amd76x_edac: convert driver to use the new edac ABI
>> 20b0b97 amd64_edac: convert driver to use the new edac ABI
>> 2818904 edac: Change internal representation to work with layers
>> 6608e65 edac.h: Add generic layers for describing a memory location
>> b9e889c edac: rewrite edac_align_ptr()
>> c3fdf60 edac: move nr_pages to dimm struct
>> e2b808a edac: Don't initialize csrow's first_page & friends when not needed
>> 0d5f849 edac: move dimm properties to struct dimm_info
>> fa3fb69 edac: Create a dimm struct and move the labels into it
> 

I'll also add a few other fixup/cleanup patches from v26 that don't
affect the core and were reviewed/tested:

0bf09e8 i7core: fix ranks information at the per-channel struct
486dfb1 i5000: Fix the fatal error handling
9f70d08 i5100_edac: Fix a warning when compiled with 32 bits
36683aa i82975x_edac: Test nr_pages earlier to save a few CPU cycles
805afb6 e752x_edac: provide more info about how DIMMS/ranks are mapped
64e1fda i5000_edac: Fix the logic that retrieves memory information

Regards,
Mauro
