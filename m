Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2KMWNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:13:47 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:49364 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab2KMWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:46 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.229;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail02v.am.sony.com;RD:mail02.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1d1ah1d2ahzzz2fh2a8h668h839h93fhd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh1155h)
Message-ID: <50A2C5C3.8040804@am.sony.com>
Date: Tue, 13 Nov 2012 14:12:19 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Thiago Farina <tfransosi@gmail.com>,
        linux list <linux-kernel@vger.kernel.org>
Subject: Re: acked-by meaning
References: <CACnwZYc4xY5r_oxu36URsSHen1kHDiStULMyB2LrZB+Eg=FF2g@mail.gmail.com> <50A07169.6090201@infradead.org>
In-Reply-To: <50A07169.6090201@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/12 19:47, Randy Dunlap wrote:
> On 11/11/2012 05:40 PM, Thiago Farina wrote:
> 
>> Hi,
>>
>> What is the meaning of 'Acked-by:' line? Is the same of LGTM? How it
>> differs from 'Reviewed-by:'?
> 

> Reviewed-by: is stronger than Acked-by:.
> If someone replies with Reviewed-by, they also accept some
> responsibility for fixing any problems that the patch might
> introduce after it is merged.

I haven't found a "responsibility for fixing any problems" in the
references provided below.  Can you help me out by pointing
to a specific sentence or another reference?

> Acked-by just means agreement with the patch.
> 
>> If someone acks a patch (can anybody acks or just the maintainer?),
>> does it mean that he will also apply the patch to his tree?
> 
> 
> Anybody can reply to a patch with Acked-by.
> No, it doesn't mean that the replying/acking person will apply
> the patch to any tree.
> 
> 
> Have you read what Documentation/SubmittingPatches and
> Documentation/development-process/5.Posting and 6.Followthrough
> say about Acked-by?

Thanks...

-Frank

