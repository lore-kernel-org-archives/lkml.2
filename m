Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0ERQoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:44:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0ERQoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:44:04 -0400
Message-ID: <4BF2C3BE.7060804@intel.com>
Date: Tue, 18 May 2010 09:43:42 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Pauli Nieminen <suokkos@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 5/7] arch/x86: Add array variants for setting memory to
 wc 	caching.
References: <1270125903-6004-1-git-send-email-suokkos@gmail.com>	 <1270125903-6004-5-git-send-email-suokkos@gmail.com> <AANLkTilyGz86DlwOvtVolthE66VzkSwj9jDv0s138Egi@mail.gmail.com>
In-Reply-To: <AANLkTilyGz86DlwOvtVolthE66VzkSwj9jDv0s138Egi@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 02:34 AM, Dave Airlie wrote:
> On Thu, Apr 1, 2010 at 10:45 PM, Pauli Nieminen <suokkos@gmail.com> wrote:
>> Setting single memory pages at a time to wc takes a lot time in cache flush. To
>> reduce number of cache flush set_pages_array_wc and set_memory_array_wc can be
>> used to set multiple pages to WC with single cache flush.
>>
>> This improves allocation performance for wc cached pages in drm/ttm.
>>
> 
> I've got this in drm-next for quite a while and almost forgot about
> it, I'm meant to be on holidays and I'd really like to just have Linus
> pull my tree,
> 
> I had only one issue with this as we had some problems with doing it
> before but it looks like they've since been fixed in the x86 pat code
> a kernel or two ago so this patch should be fine now.
> 
> its been well tested in drm-next on AGP machines by the author,
> 
> any objections to this?
> 
> Dave.

Acked-by: H. Peter Anvin <hpa@zytor.com>

Go ahead and push it; the patch is straightforward, and the author
(Venki) is reliable.

	-hpa

P.S. Please Cc: all the x86 maintainers, not just Ingo.
