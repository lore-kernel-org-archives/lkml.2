Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab2HXUrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:47:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39316 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933305Ab2HXUrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:47:33 -0400
Message-ID: <5037E845.2010306@zytor.com>
Date: Fri, 24 Aug 2012 13:47:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Brian Gerst <brgerst@gmail.com>, wbrana <wbrana@gmail.com>,
        Martin Nybo Andersen <tweek@tweek.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drop support for x86-32
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208231814.21168.tweek@tweek.dk> <CAJ7jCmmJ4DrGkebgG1a03+grs5PX3D86thdZ5mK361CYNaP6HQ@mail.gmail.com> <CAMzpN2ioV-DjNDKJQwKebSRAuGO=BnYMtutLWPRoUOqx_sA-3g@mail.gmail.com> <5037C530.3000408@zytor.com> <20120824185741.GC5094@thunk.org> <20120824201358.0f086c9a@pyramind.ukuu.org.uk> <20120824195856.GD5094@thunk.org> <20120824200642.GA8543@redhat.com> <20120824202544.GA23427@liondog.tnic>
In-Reply-To: <20120824202544.GA23427@liondog.tnic>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 01:25 PM, Borislav Petkov wrote:
> On Fri, Aug 24, 2012 at 04:06:42PM -0400, Dave Jones wrote:
>> On Fri, Aug 24, 2012 at 03:58:56PM -0400, Theodore Ts'o wrote:
>>
>>  > BTW, it turns out I was wrong about Linux being used on Mars.
>>  > Apparently Linux was used on the Mars Global Surveyor, as well as the
>>  > Sprit and Opportunity rovers
>>
>> citation? My recollection was that they were running VxWorks.
> 
> ... on a "a radiation-hardened version of the IBM PowerPC 750." So no
> x86.
> 
> http://www.pcmag.com/article2/0,2817,2408127,00.asp
> 

That is Curiosity (Mars Science Laboratory), not Spirit/Opportunity
(Mars Exploration Rover).

However, Wikipedia lists the CPU on the MERs as a 20 MHz IBM RAD6000
CPU, running VxWorks.

If you want x86, there are definitely newer things than 386:

	http://www.sandia.gov/media/rhp.htm

... that was almost 14 years ago now.

	-hpa
