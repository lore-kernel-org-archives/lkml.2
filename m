Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1IPOwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:52:12 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:50479 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1IPOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:52:11 -0400
Message-ID: <4E736297.2070604@gmail.com>
Date: Fri, 16 Sep 2011 08:52:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com> <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com> <4E6E181E.9080506@gmail.com> <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com> <1315838611.26517.51.camel@twins> <CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com> <1316183832.10174.28.camel@twins> <CABPqkBRmpnMNH16_HNWWHFn8dDtTE+jRjunkLDpc30SnA8_oYA@mail.gmail.com>
In-Reply-To: <CABPqkBRmpnMNH16_HNWWHFn8dDtTE+jRjunkLDpc30SnA8_oYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/16/2011 08:44 AM, Stephane Eranian wrote:
>> Sure, but all you need to know is if the file you're reading is a
>> different endian than your box, if it is swap stuff, if its not, you're
>> good.
> 
> We agree on that. I am just saying the MAGIC string as it is today
> may not be enough to tell us that.

Right. I think that's why the attribute struct is used to detect
endianness and not the magic.

David
