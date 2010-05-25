Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201Ab0EYUln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:41:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934159Ab0EYUlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:41:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=vawPrkxbMUxW79bdIWr4fJMNEMQH5fc5cPvgafSrRGdl4dt9GfgVoREG2L2Wrk6Cl
	+8iDBz8zdcIDPFsDzdzng==
MIME-Version: 1.0
In-Reply-To: <20100525171411.GA3548@suse.de>
References: <20100524231840.GA17857@kroah.com>
	<20100524231815.713224572@clark.site>
	<AANLkTilMq6zUgCus6_suEjAcTPYY7Ao0gCvrWHkTe9F6@mail.gmail.com>
	<20100525171411.GA3548@suse.de>
Date: Tue, 25 May 2010 13:41:37 -0700
Message-ID: <AANLkTilJxUz_24qlnXdpKOTBzDTDAy2Q628UmFplXkML@mail.gmail.com>
Subject: Re: [28/39] x86, cacheinfo: Turn off L3 cache index disable feature 
	in virtualized environments
From: Hugh Dickins <hughd@google.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 10:14 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, May 24, 2010 at 06:50:20PM -0700, Hugh Dickins wrote:
>> On Mon, May 24, 2010 at 4:15 PM, Greg KH <gregkh@suse.de> wrote:
>> >
>> > 2.6.33-stable review patch.  If anyone has any objections, please let us know.
>> >
>> > ------------------
>> > From: Frank Arnold <frank.arnold@amd.com>
>> >
>> > commit 7f284d3cc96e02468a42e045f77af11e5ff8b095 upstream.
>>
>> Closer, but aren't all the XX/34s intended for 2.6.32.14, not 2.6.33.5?
>
> Yes.  This one is a XX/39 and for the .33 tree.

Sorry for wasting your time with that noise: you must think I'm mad,
but it appears to be a delightful feature of gmail, combining similar mails:
to me the Subject line says 20/34, but looking at marc I find as you say,
that I have replied to 28/39.

That's going to be a problem!

>
>> I'm trying to check whether my kernel/profile.c fix (18/34) is in for
>> both 2.6.32.14 and 2.6.33.5, but getting too confused to tell!
>
> Yes, I see it in both trees.

Thanks for your eyes: mine of course can only see it in one.

Hugh
