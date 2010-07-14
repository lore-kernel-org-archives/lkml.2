Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0GNJHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:07:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39196 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0GNJHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:07:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MjhAmn8oso+3yZC51Z1+HqrmDzPX5LmdM0643joYnhX831ESe0/qMGHHlr5NVAFoKm
         eroNYHC5dhWPVJBroiRs2CA6PlUEHVNKhwBjVPoMPGAoWXXMo5dusy/LdgKPCK8gPiHi
         40SJXWx9aP5qH5SXsDMtrNAvpSKbFMVDnEn7k=
MIME-Version: 1.0
In-Reply-To: <1279058027.936.236.camel@calx>
References: <1278756333-6850-1-git-send-email-lliubbo@gmail.com>
	<AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
	<1279058027.936.236.camel@calx>
Date: Wed, 14 Jul 2010 12:07:44 +0300
X-Google-Sender-Auth: cUVzxLJOWMUsVRVvBMUZq7P0dHI
Message-ID: <AANLkTil-sv82zjR7yJr_3nZ0QBO_8Jwj_FO0iFubwe2s@mail.gmail.com>
Subject: Re: [PATCH] slob_free:free objects to their own list
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Matt Mackall <mpm@selenic.com>
Cc: Bob Liu <lliubbo@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org,
        hannes@cmpxchg.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 12:53 AM, Matt Mackall <mpm@selenic.com> wrote:
> On Tue, 2010-07-13 at 20:52 +0300, Pekka Enberg wrote:
>> Hi Bob,
>>
>> [ Please CC me on SLOB patches. You can use the 'scripts/get_maintainer.pl'
>>   script to figure out automatically who to CC on your patches. ]
>>
>> On Sat, Jul 10, 2010 at 1:05 PM, Bob Liu <lliubbo@gmail.com> wrote:
>> > slob has alloced smaller objects from their own list in reduce
>> > overall external fragmentation and increase repeatability,
>> > free to their own list also.
>> >
>> > Signed-off-by: Bob Liu <lliubbo@gmail.com>
>>
>> The patch looks sane to me. Matt, does it look OK to you as well?
>
> Yep, this should be a marginal improvement.
>
> Acked-by: Matt Mackall <mpm@selenic.com>

Great! Bob, if you could provide the /proc/meminfo numbers for the
patch description, I'd be more than happy to merge this.

                        Pekka
