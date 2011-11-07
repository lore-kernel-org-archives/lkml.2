Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1KGOf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:35:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:22612 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1KGOf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:35:58 -0500
MIME-Version: 1.0
Message-ID: <e3566bd4-bf52-4e75-87bd-d42debcc07b6@default>
Date: Mon, 7 Nov 2011 06:35:27 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Neo Jia <cyclonusj@gmail.com>,
        levinsasha928@gmail.com, JeremyFitzhardinge <jeremy@goop.org>,
        linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Chris Mason <chris.mason@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, ngupta@vflare.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: RE: [GIT PULL] mm: frontswap (SUMMARY)
References: <20111104164532.GO18879@redhat.com>
 <d19dddac-0713-47bf-bec7-04cc8d534b50@default
 CAOJsxLFXy7-u+G_MLUnD3+kYqxsbns4dQV2WEpBu2oCJ4PtT7A@mail.gmail.com>
In-Reply-To: <CAOJsxLFXy7-u+G_MLUnD3+kYqxsbns4dQV2WEpBu2oCJ4PtT7A@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EB7ECB5.0151,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Subject: Re: [GIT PULL] mm: frontswap (SUMMARY)
> 
> On Sun, Nov 6, 2011 at 9:31 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > A farewell haiku:
> >
> > Crash test dummy folds.
> > KVM mafia wins.
> > Innovation cries.
> 
> Does this mean you've stopped working on frontswap or that frontswap
> is dead? What does this mean for the cleancache hooks? Are they still
> useful?

Wow.  F***ing incredible.

Pekka, you'd best leave the politics to Andrea.  He's
_much_ better at it.

No, I haven't stopped, though I may be pausing to lick
my wounds.  No it's not dead yet.  Yes, the cleancache
hooks are still useful, so narrow-minded anti-Xen
vultures can go circle elsewhere.

Since my attempt at gracefully ending the discussion
with poetry has been ruined, I might as well spell it out:

"Crash test dummy folds":  (1) Andrew, I'm warning you
(from the first crash test dummy) that the new process
may be too heavy handed and corruptible.  (2) I've taken
enough beatings for now, thank you.

"KVM mafia wins" :  If one reads between the many
(far too many) lines of this discussion, and as further
evidenced by Pekka's reply, the anti-Xen crowd has
been losing too many battles recently, is damn
well not going to lose this one, and would like
by any means possible to reverse previous losses.
People, can't we just get along?

"Innovation cries":  I'm expressing sadness that
a very innovative and elegant approach to a very
hard problem, that began Xen-specific but seems
to have lots of interesting uses, is being blocked
for political reasons.  I'm not denying that there
is plenty of work still to be done, just arguing
that this can best be explored as a community
project... and that's not going to happen by
conveniently ignoring the most mature user (Xen)
because one has a personal or corporate vendetta
against it.

Frontswap should be in-tree.  For anyone familiar
with the American political system, frontswap
has been blocked by a filibuster.

I won't be responding to further posts on this
topic for awhile, for health reasons.
