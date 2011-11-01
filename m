Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab1KAE6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 00:58:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:41867 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab1KAE6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 00:58:46 -0400
Date: Mon, 31 Oct 2011 21:58:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
In-Reply-To: <CA+55aFy=Wz4zxjoPJer=OfA2Jsh1FA_ahUpa8sw=5UJuAyEsFQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1110312151040.31794@asgard.lang.hm>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
 <4EAF1FF6.3000500@zytor.com> <CA+55aFw-kvshWmAVFVSa11cNU0AbAu3R5djboR8ysj0tYp1p-A@mail.gmail.com> <alpine.DEB.2.02.1110311915160.31794@asgard.lang.hm> <CA+55aFy=Wz4zxjoPJer=OfA2Jsh1FA_ahUpa8sw=5UJuAyEsFQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011, Linus Torvalds wrote:

> On Mon, Oct 31, 2011 at 7:17 PM,  <david@lang.hm> wrote:
>>
>> what IMAP servers have you used? I find that with a good IMAP server I can
>> get away with _very_ little processing power in the client and get good
>> performance (I still am using pine, but with a cyrus IMAP server)
>
> I've used pine (and then alpine) to cyrus servers too. That was what
> LF used to have on the server side. It absolutely sucked.
>
> That combination is supposed to do server-side searching etc, but you
> couldn't tell from the performance. It was disgusting.

interesting, that's the setup I have and the server side searching works 
well for me (searching for random text works much better if I have the 
server update it's squatter indexes frequently). I did find that different 
filesystems made a HUGE difference in system performance (with ext2/3 
being the worst). I use XFS, but I see a lot of people reporting good 
results with ext4, btrfs, and ZFS.

the biggest folder I have has >250K messages in it and takes >20G. random 
text searches on that take 5-10 seconds (much better than I could do on 
my local drives)

> I'm sure it works much better with a fast local network, but quite
> frankly, that obviates the need for IMAP in the first place. If you
> have your mail locally, there are better models than IMAP for handling
> it.

I agree that it's not strictly needed if you store everything local, but I 
don't want to have all that mail on my non-mirrored, small laptop drive 
(even if it is a SSD). I've suffered too many disk failures over the years 
to not have my mail store on redundant drives :-)

David Lang

> So the only situation I've found IMAP reasonable has been at corporate
> settings where you're not talking DSL or cable modem speeds, but use
> IMAP as a way to avoid NFS-mounting the mail spool, which is even
> worse. But actually working over slowish internet connections? No
> thank you.
>
>                         Linus
>
