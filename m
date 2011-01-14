Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1ANXeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:34:17 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:53009 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab1ANXeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:34:15 -0500
Message-ID: <4D30DD6C.4010507@kernel.org>
Date: Fri, 14 Jan 2011 15:34:04 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>, Nick Piggin <npiggin@gmail.com>,
        patchwork@lists.ozlabs.org, Al Viro <viro@zeniv.linux.org.uk>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, webmaster@kernel.org
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
References: <7352.1294971049@jrobl>	<AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>	<20110114052813.GZ19804@ZenIV.linux.org.uk>	<AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com> <AANLkTik=7x9o3s_TeVAACjNachLE7zyrbqyOeBBiE-v5@mail.gmail.com>
In-Reply-To: <AANLkTik=7x9o3s_TeVAACjNachLE7zyrbqyOeBBiE-v5@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Fri, 14 Jan 2011 15:34:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [ CCing patchwork ML ]
> 
> Can you send your patch separately, please?
> Within a (long) thread it is eaten up.
> 
> As *.patch are somehow not presented as diff (see [1]), someone can't
> catch them from <patchwork.k.o>.

On a side note, due to some conversations with the ocfs2 devs yesterday,
I've actually got the vfs-scale code sitting compiled up waiting for
another kernel panic to happen on the dynamic web boxes, since 2.6.37+
was, literally, unusable with ocfs2 running.

> Furthermore, it would be very cool to see linux-fsdevel (patches from
> its ML) in <patchwork.d.o>.
> I don't know whom to contact from the linux-fsdevel ML, sorry for this.

As to getting a mailing list added into patchwork.kernel.org I just need
a request from someone who is responsible for the mailing list, and who
will actually use the resulting entry in patchwork to e-mail
ftpadmin@kernel.org with the mailing list, where I can deal with the
sign-up and the name / username of the individual (in patchwork) to add
as being in charge.

- John 'Warthog9' Hawley
