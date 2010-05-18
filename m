Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0ERUyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:54:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48399 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0ERUyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O6Y93HGSA5bUa0n+kpQYNR+BEnkodgiEW+DV+74F9HzplGiKKqguly9kMaUjiHOJg2
         cWjlLHADwsPl8B8gub72ZEbGtHAS/tDFYfOn4V1daHfekZ7pWxjxrmDJyct3AeMRTyU5
         zOhF9f3WJBkMeQWB7KJrRjzPfOOu5m68BioL8=
MIME-Version: 1.0
In-Reply-To: <4BF2C3BE.7060804@intel.com>
References: <1270125903-6004-1-git-send-email-suokkos@gmail.com>
	 <1270125903-6004-5-git-send-email-suokkos@gmail.com>
	 <AANLkTilyGz86DlwOvtVolthE66VzkSwj9jDv0s138Egi@mail.gmail.com>
	 <4BF2C3BE.7060804@intel.com>
Date: Tue, 18 May 2010 13:54:12 -0700
Message-ID: <AANLkTil-PxC3C8cuPsZG6hKNzzq9MmKNtcY1IhnDy0OU@mail.gmail.com>
Subject: Re: [PATCH 5/7] arch/x86: Add array variants for setting memory to wc 
	caching.
From: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Dave Airlie <airlied@gmail.com>, Pauli Nieminen <suokkos@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 9:43 AM, H. Peter Anvin <h.peter.anvin@intel.com> wrote:
> On 05/18/2010 02:34 AM, Dave Airlie wrote:
>> On Thu, Apr 1, 2010 at 10:45 PM, Pauli Nieminen <suokkos@gmail.com> wrote:
>>> Setting single memory pages at a time to wc takes a lot time in cache flush. To
>>> reduce number of cache flush set_pages_array_wc and set_memory_array_wc can be
>>> used to set multiple pages to WC with single cache flush.
>>>
>>> This improves allocation performance for wc cached pages in drm/ttm.
>>>
>>
>> I've got this in drm-next for quite a while and almost forgot about
>> it, I'm meant to be on holidays and I'd really like to just have Linus
>> pull my tree,
>>
>> I had only one issue with this as we had some problems with doing it
>> before but it looks like they've since been fixed in the x86 pat code
>> a kernel or two ago so this patch should be fine now.
>>
>> its been well tested in drm-next on AGP machines by the author,
>>
>> any objections to this?
>>
>> Dave.
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
> Go ahead and push it; the patch is straightforward, and the author
> (Venki) is reliable.
>
>        -hpa
>
> P.S. Please Cc: all the x86 maintainers, not just Ingo.
>

Patch actually from Pauli.
Looks good.

Acked-by: Venkatesh Pallipadi <venki@google.com>
