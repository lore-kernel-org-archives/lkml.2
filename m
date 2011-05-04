Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1EDHdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:33:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1EDHdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sdeeBEyOh2i0zuD91C0aqxco2pTuJHF6HCgCfqa+k5v4inGOJgrWt7HQYdIP4UZAmp
         kx36xxEh5d/UOdzj9P1KaZaxCJ7xxV92ygnVURRk6+GzRkeoUUxuRmfil3pvSPaInB09
         E6LCdXvfhO9RBWggA4XB3nffpkr4hWw+SzjX8=
MIME-Version: 1.0
In-Reply-To: <20110504040018.GB6500@localhost>
References: <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
	<20110426062535.GB19717@localhost>
	<BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
	<20110426063421.GC19717@localhost>
	<BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
	<20110426092029.GA27053@localhost>
	<20110426124743.e58d9746.akpm@linux-foundation.org>
	<20110428133644.GA12400@localhost>
	<BANLkTimpT-N5--3QjcNg8CyNNwfEWxFyKA@mail.gmail.com>
	<20110504040018.GB6500@localhost>
Date: Wed, 4 May 2011 15:33:32 +0800
Message-ID: <BANLkTimCK9kxrepvvCjXDNEhWaX2sxC5zA@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: cut down __GFP_NORETRY page allocation failures
From: Dave Young <hidave.darkstar@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 12:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > CAL:     220449     220246     220372     220558     220251     219740     220043     219968   Function call interrupts
>> >
>> > LOC:     536274     532529     531734     536801     536510     533676     534853     532038   Local timer interrupts
>> > RES:       3032       2128       1792       1765       2184       1703       1754       1865   Rescheduling interrupts
>> > TLB:        189         15         13         17         64        294         97         63   TLB shootdowns
>>
>> Could you tell how to get above info?
>
> It's /proc/interrupts.
>
> I have two lines at the end of the attached script to collect the
> information, and another script to call getdelays on every 10s. The
> posted reclaim delays are the last successful getdelays output.
>
> I've automated the test process, so that with one single command line
> a new kernel will be built and the test box will rerun tests on the
> new kernel :)

Thank you for that effort!

>
> Thanks,
> Fengguang
>



-- 
Regards
dave
