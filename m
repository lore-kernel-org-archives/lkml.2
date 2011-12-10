Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1LJU4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 15:56:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:49925 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LJU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 15:56:12 -0500
Date: Sat, 10 Dec 2011 21:56:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [GIT pull] x86 fixes for 3.2
In-Reply-To: <CA+55aFyO2yiTLmM67JMq3f3pLeuc5pKk2fPdC80PSV_YT6LfvQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1112102154130.3020@ionos>
References: <alpine.LFD.2.02.1112092128150.3020@ionos> <CA+55aFyO2yiTLmM67JMq3f3pLeuc5pKk2fPdC80PSV_YT6LfvQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-179979404-1323550570=:3020"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-179979404-1323550570=:3020
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 9 Dec 2011, Linus Torvalds wrote:

> On Fri, Dec 9, 2011 at 12:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Please pull the latest x86-urgent-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus
> 
> Christ, Thomas - fix your script already, and learn to double-check
> your pull requests.
> 
> That is *not* a valid repository. There's nothing there. Stop pointing
> me at it, dammit!

Me culpa. I fixed the script, but missed to deploy the update on my
main devel machine from which I generated the pull request. Won't
happen again.

Thanks,

	tglx
--8323328-179979404-1323550570=:3020--
