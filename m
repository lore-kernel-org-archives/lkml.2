Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab0HMQTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:19:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53718 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761770Ab0HMQTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=xedxmhyqCHLx6rsnpYP98ioOH4v8QMu/TBdR28yJMFFLfCw2KJ0qTCotXK+xN8YSzk
         LgbULRlZP45Szxig0NnSRm5CQlwH6KZThAuF5a845aA6BQ7VlAaYmpc8G3K/Ov98ruzw
         xDXXK2lUsOAWG181ZgUxyHoi06XgR5U6U7ygc=
MIME-Version: 1.0
In-Reply-To: <20100813155738.GA11507@isilmar-3.linta.de>
References: <20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812174303.GD2524@linux.vnet.ibm.com>
	<AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	<20100813152254.GD2511@linux.vnet.ibm.com>
	<AANLkTimdpgC2DBn1pS2OG35+_06-L6TZ9Q_nb+C6Yeqv@mail.gmail.com>
	<20100813155738.GA11507@isilmar-3.linta.de>
Date: Fri, 13 Aug 2010 19:19:33 +0300
Message-ID: <AANLkTikN2zKcLtFJ6EdBU=iqT78bZKt_rKQoPNBRXJHj@mail.gmail.com>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread,
 take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>, paulmck@linux.vnet.ibm.com,
        david@lang.hm, Theodore Tso <tytso@mit.edu>, peterz@infradead.org,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de, galibert@pobox.com, florian@mickler.org,
        menage@google.com, linux-pm@lists.linux-foundation.org,
        swmike@swm.pp.se, tglx@linutronix.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, arjan@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 6:57 PM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>> >> Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
>> >> user-space seems to be having this problem. I can argue to you that
>> >> this problem can be solved in easier ways, but instead I will argue
>> >> that perhaps we should wait for somebody besides Android to complain
>> >> about it before providing a "solution". Because after all, what good
>> >> is a "solution" provided by the kernel, if the user-space is not going
>> >> to use it, ever.
>> >
>> > At this point in the discussion, I am quite prepared to believe that you
>> > will avoid using suspend blockers, and that you will further do everything
>> > in your power to prevent anyone else from using suspend blockers.  ;-)
>>
>> I'm not tying anybody's hands.
>>
>> How are people using real-time linux if it's not on mainline? Well,
>> duuh, you apply the patches. If say Fedora was interested on it, they
>> could apply the patches, and see for themselves. People do that all
>> the time, with the mm tree, with Con Koliva's patches, etc. Once
>> people are happy with the results, things get merged. Why should this
>> be any different?
>
> Because millions of users are happy -- with Android, including suspend
> blockers.

I explicitly said somebody besides Android, specifically, somebody
with a typical linux ecosystem. You are not addressing the argument at
hand, that nobody else wants to tackle the issue this way, thus only
making the discussion more difficult.

-- 
Felipe Contreras
