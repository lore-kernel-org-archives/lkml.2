Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804Ab1JaXEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:04:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64978 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaXEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF2724.8040001@zytor.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <4EAF1F40.3030907@zytor.com> <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com> <7vzkggok6u.fsf@alter.siamese.dyndns.org>
 <CA+55aFwnVZ-mK3FChvFn778Z-cT107f4v-h0CDmwkP88=Z9aHA@mail.gmail.com> <4EAF2724.8040001@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 16:03:48 -0700
X-Google-Sender-Auth: dleJEiVu6sp4Ampjq79X98HjncE
Message-ID: <CA+55aFxAcNW4obDzQ3fKvaBwj0Ssx_TD-RgrBaJ=Tb4hRtr4DA@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 3:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/31/2011 03:52 PM, Linus Torvalds wrote:
>>
>> Save it in the commit we generate. BAM! Useful, readable, permanent,
>> and independently verifiable.
>>
>
> Note: this means creating a commit even for a fast-forward merge.  Not
> that there is any technical problem with that, of course.

Well, only for the signed case, but yes. And for that case it's likely
a good thing.

In fact, even without signing, some projects always use --no-ff,
because they want the merge messages with the nice summary in them.
I've played around with it too, but haven't generally found it to be
worth it, and tend to think that it aggrandizes the merger too much.

It generates nice merge summaries, and it can look nice, but if the
*only* upside is the merge summary I think it's borderline worth it.
But with a signature, it would suddenly actually contain real
information, and I think that changes the equation.

                           Linus
