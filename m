Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab1KPCfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:35:15 -0500
Received: from ozlabs.org ([203.10.76.45]:39050 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627Ab1KPCdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
In-Reply-To: <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au> <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy> <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au> <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com> <20111109195901.GA28155@redhat.com> <1320870287.3730.6.camel@lappy> <20111109205208.GA28599@redhat.com> <1320872248.3730.11.camel@lappy> <87aa83qoao.fsf@rustcorp.com.au> <CA+1xoqeH3ErNCELD+NoJHz=eH6FtxersUffoJSj0yQx2o=4g0g@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 16 Nov 2011 10:28:52 +1030
Message-ID: <87aa7xos3n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011 09:39:13 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Fri, Nov 11, 2011 at 6:24 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > (2) There's no huge win in keeping the same layout.  Let's make some
> >    cleanups.  There are more users ahead of us then behind us (I
> >    hope!).
> 
> Actually, if we already do cleanups, here are two more suggestions:
> 
> 1. Make 64bit features a one big 64bit block, instead of having 32bits
> in one place and 32 in another.
> 2. Remove the reserved fields out of the config (the ones that were
> caused by moving the ISR and the notifications out).

Yes, those were exactly what I was thinking.  I left it vague because
there might be others you can see if we're prepared to abandon the
current format.

Cheers,
Rusty.
