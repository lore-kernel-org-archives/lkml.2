Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1KAD0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:26:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42051 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab1KAD0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:26:15 -0400
Message-ID: <4EAF66C7.6080909@zytor.com>
Date: Mon, 31 Oct 2011 20:25:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: david@lang.hm
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com> <4EAF1FF6.3000500@zytor.com> <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com> <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 07:17 PM, david@lang.hm wrote:
> 
> what IMAP servers have you used? I find that with a good IMAP server I
> can get away with _very_ little processing power in the client and get
> good performance (I still am using pine, but with a cyrus IMAP server)
> 
> there are a bunch of IMAP servers out there that are horrible (and even
> more IMAP clients that are really doing POP and storing everything
> locally, just using the IMAP protocol)
> 

Last I checked if you used pine against an IMAP server it did absolutely
no caching, in which case you're of course screwed.

I use IMAP on my phone, and with Thunderpants... I mean Thunderbird...
and it works quite nicely.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

