Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0IJNKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:10:42 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:36734 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab0IJNKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:10:41 -0400
Date: Fri, 10 Sep 2010 15:10:35 +0200
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [stable] [tip:x86/urgent] x86: Add memory modify constraints
	to xchg() and cmpxchg()
Message-ID: <20100910131035.GA16636@nomi.cz>
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <4C5759FF.1000807@goop.org> <20100802235950.GA662@kroah.com> <20100909195301.GA18291@nomi.cz> <4C894E64.3050800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C894E64.3050800@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 09, 2010 at 02:15:16PM -0700, H. Peter Anvin wrote:
> > The system boots and works just fine with 2.6.32.21 with the patch reverted.
> > v2.6.36-rc3-185-gd56557a works fine as well, perhaps there were other fixes
> > that didn't get to stable (e.g. 4532b30).
> 
> I believe this needs 69309a05907546fb686b251d4ab041c26afe1e1d, which I
> think is being queued up for stable.
> 
> Could you try applying 69309a05907546fb686b251d4ab041c26afe1e1d and see
> if it solves your problem.

It does indeed. Thanks.

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
