Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706Ab1JaWrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:47:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40770 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934617Ab1JaWrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:47:20 -0400
Message-ID: <4EAF2567.5080108@zytor.com>
Date: Mon, 31 Oct 2011 15:47:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com> <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com> <4EAF1F40.3030907@zytor.com> <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com> <4EAF2245.90308@zytor.com> <7vzkggok6u.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vzkggok6u.fsf@alter.siamese.dyndns.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 03:44 PM, Junio C Hamano wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> On 10/31/2011 03:30 PM, Linus Torvalds wrote:
>>>
>>> But if you do the normal "git pull git://git.kernel.org/name/of/repo"
>>> - which is how things happen as a result of a pull request - you won't
>>> get tags at all - you have to ask for them by name or use "--tags" to
>>> get them all.
>>>
>>
>> Didn't realize that... I guess I'm too used to named remotes.
>>
>> If so, just using a tag should be fine, no?
> 
> So nobody is worried about this (quoting from my earlier message)?
> 
>    On the other hand, the consumers of "Linus kernel" may want to say that
>    they trust your tree and your tags because they can verify them with your
>    GPG signature, but also they can independently verify the lieutenants'
>    trees you pulled from are genuine.
> 
> A signed emphemeral tag is usable as means to verify authenticity in a
> hop-by-hop fashion, but that does not leave a permanent trail that can be
> used for auditing.
> 

Well, the permanent trail is in the maintainer's tree, but that might
still be suboptimal.  The problem with Linus pulling those tags I assume
that it makes the tree too noisy?

	-hpa

