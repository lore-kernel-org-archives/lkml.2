Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1H3HJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:09:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:27669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1H3HJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:09:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43519071"
From: Andi Kleen <andi@firstfloor.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com>
	<CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
	<4E582EAA.1040108@zytor.com>
	<CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
	<CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
	<4E584492.5090406@zytor.com>
	<CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
	<CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
	<CA+55aFzuY+U0nf58-9P5CFaYAPKMQ3fQMGGUUkjbxRRCK7=A3Q@mail.gmail.com>
	<CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
Date: Tue, 30 Aug 2011 00:09:00 -0700
In-Reply-To: <CAGZ=bqKjnsEKz_CxcW+wRoCL_CY-kipedf2wB=BVUWRB0427tw@mail.gmail.com>
	(Kyle Moffett's message of "Mon, 29 Aug 2011 22:16:56 -0400")
Message-ID: <m2ty8znzoz.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <kyle@moffetthome.net> writes:

Old wisdom, as wrong as always.

> The only programs which really care are those which map many gigs
> of stuff into memory (IE: big databases, etc). 

You mean anything that mmaps a file?

2-3GB is not a whole lot these days.

2Gb is a very similar thing as Linus y2038, just you're much more
likely to hit it.

IMHO the only excuse right now for 32bit is to use it in a JIT
that can dynamically expand the pointer. Or for old binaries.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
