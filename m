Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0E1E6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:58:11 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:46578 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab0E1E6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kU63rkRTZWGkiIeHuZMFGZTQr6vWU3GpfDGQH8rDzy0MYzf/AT3UVIA2SyZT06EKon
         N6Bxs0MR9cjc25Xu42n0v7ntW92Bl/OCdjYFd4LdKwFxQLDAp2iEhKz8bW2joI0nUtGZ
         AOpO0cHAWnUp9MRaIAfkC8+KL5Z0vdlL9tQrU=
MIME-Version: 1.0
In-Reply-To: <20100527231538.GA1615@mcafee.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<1274863506-14168-1-git-send-email-vapier@gentoo.org> <4BFE2C3E.5090704@monstr.eu> 
	<AANLkTinD5VI-piiv6CWnZMei4ARTLDF61r0O7wvddRDP@mail.gmail.com> 
	<20100527231538.GA1615@mcafee.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 28 May 2010 00:57:46 -0400
Message-ID: <AANLkTilwG3e_hUVl3ZbRUUxUCGoPR-1b-Yn-xF2m8_Rd@mail.gmail.com>
Subject: Re: [microblaze-uclinux] Re: [Uclinux-dist-devel] [PATCH 1/2 v2] 
	FLAT: split the stack & data alignments
To: David McCullough <david_mccullough@mcafee.com>
Cc: microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu,
       linux-m32r@ml.linux-m32r.org, uclinux-dev@uclinux.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 19:15, David McCullough wrote:
> Jivin Mike Frysinger lays it down ...
>> On Thu, May 27, 2010 at 04:24, Michal Simek wrote:
>> > Mike Frysinger wrote:
>> >> The stack and data have different alignment requirements, so don't force
>> >> them to wear the same shoe. ??Increase the data alignment to match that
>> >> which the elf2flt linker script has always been using: 0x20 bytes. ??Not
>> >> only does this bring the kernel loader in line with the toolchain, but
>> >> it also fixes a swath of gcc tests which try to force larger alignment
>> >> values but randomly fail when the FLAT loader fails to deliver.
>> >
>> > Solve the problem on Microblaze:
>> >
>> > Tested-by: Michal Simek <monstr@monstr.eu>
>> >
>> > Who will add it to mainline?
>>
>> if we can get the misc nommu peeps to agree on this (looking mostly at
>> David [McCullough] and Greg), then akpm will most likely expedite the
>> merge.  i like to think they're the best FLAT experts out there ;).
>
> Did the latest patch include the changes Paul requested.
>
> It looks like it to me,  I've just been a bit distracted.  If so I'll send
> in an Ack.

i dont want to rush you or something ... the patches need to be in
before 2.6.35 is released (since trouble started with a patched added
to 2.6.35 merge window), so if you want to review things a bit more,
it should be OK ..
-mike
