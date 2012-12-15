Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2LOViS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 16:38:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2LOViR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 16:38:17 -0500
Date: Sat, 15 Dec 2012 16:37:47 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jan Beulich <jbeulich@suse.com>, Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
Message-ID: <20121215213747.GA2783@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Jan Beulich <jbeulich@suse.com>,
	Matt Fleming <matt.fleming@intel.com>,
	David Howells <dhowells@redhat.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CCD24F.9090603@zytor.com>
 <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 11:58:00AM -0800, Linus Torvalds wrote:

 > It might also be that it causes some massive corruption at boot time,
 > but it then requires that that particular memory is actually used. So
 > maybe it's not so much about the memory map except indirectly.

I wonder if this might explain the XFS corruption I've been seeing
the last couple days.  Won't be able to get at the affected laptop
until Monday to find out..

	Dave

