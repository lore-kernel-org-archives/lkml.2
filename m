Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab1KAFDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 01:03:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:44400 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab1KAFDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 01:03:53 -0400
Date: Mon, 31 Oct 2011 22:03:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
In-Reply-To: <4EAF66C7.6080909@zytor.com>
Message-ID: <alpine.DEB.2.02.1110312158420.31794@asgard.lang.hm>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
 <4EAF1FF6.3000500@zytor.com> <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com> <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm> <4EAF66C7.6080909@zytor.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011, H. Peter Anvin wrote:

> On 10/31/2011 07:17 PM, david@lang.hm wrote:
>>
>> what IMAP servers have you used? I find that with a good IMAP server I
>> can get away with _very_ little processing power in the client and get
>> good performance (I still am using pine, but with a cyrus IMAP server)
>>
>> there are a bunch of IMAP servers out there that are horrible (and even
>> more IMAP clients that are really doing POP and storing everything
>> locally, just using the IMAP protocol)
>>
>
> Last I checked if you used pine against an IMAP server it did absolutely
> no caching, in which case you're of course screwed.

my biggest gripe with most IMAP clients is that they try so hard to cache 
everything locally that you may as well just copy the mail locally to 
begin with...

David Lang

> I use IMAP on my phone, and with Thunderpants... I mean Thunderbird...
> and it works quite nicely.
>
> 	-hpa
>
>
