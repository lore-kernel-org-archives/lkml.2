Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab1ANJam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:30:42 -0500
Received: from www.tglx.de ([62.245.132.106]:52705 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1ANJag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:30:36 -0500
Date: Fri, 14 Jan 2011 10:29:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <npiggin@gmail.com>
cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
In-Reply-To: <AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6> <8952.1294927845@jrobl> <alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6> <AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-896761190-1294997396=:2678"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-896761190-1294997396=:2678
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 14 Jan 2011, Nick Piggin wrote:

> On Fri, Jan 14, 2011 at 3:41 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 13 Jan 2011, J. R. Okajima wrote:
> >> Thomas Gleixner:
> >> > The dcache scalability work broke NFS root filesystems.
> >>       :::
> >> > Check for parent equal dentry and skip the nested lock to avoid the
> >> > deadlock. I'm sure this is the wrong fix, but at least it "works" :)
> >>
> >> With this patch, can you unmount it cleanly?
> >> It skips incrementing d_count for both dentries.
> >> Do we need at least one?
> >
> 
> Yeah thanks everyone for reporting this.
> 
> I have a fix for it in a slightly different way, and a couple of other reported
> bugs, which are going through stress testing now.

Can you point us to the patches, so we can run our own set of
tests in paralell?

Thanks,

	tglx
---1463795968-896761190-1294997396=:2678--
