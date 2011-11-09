Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1KIJHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:07:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35265 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754749Ab1KIJG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:06:58 -0500
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX18chmE4BEscKiEYqpdcg0e025UGoVbaCEZ5xrPgls
	6LMV2yE+Xp7fHL
Message-ID: <4EBA42AF.3000501@gmx.net>
Date: Wed, 09 Nov 2011 10:06:55 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Chris Mason <chris.mason@oracle.com>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com> <4EB8DEAC.7000906@gmx.net> <20111109010701.GI4149@shiny> <20111109074847.GA16742@infradead.org>
In-Reply-To: <20111109074847.GA16742@infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2011 08:48, Christoph Hellwig wrote:
> On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
>> Looks like bio_add_page() is failing and we're getting the enomem from
>> there.  LVM is only letting us put one page in each bio.
> 
> Yes, at the moment all bio based DM targets only allow single page I/O.

That's... unexpected. I guess this won't change with 3.3? For 3.3 I have
to rework that part from scrub to account for Chris' bigblocks. If it can
wait that long I'd prefer to fix both at once. Chris?

-Arne

