Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0IIVJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:09:38 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:47248 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab0IIVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:09:36 -0400
Date: Thu, 9 Sep 2010 23:09:35 +0200
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
Message-ID: <20100909210935.GA13879@nomi.cz>
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <4C5759FF.1000807@goop.org> <20100802235950.GA662@kroah.com> <20100909195301.GA18291@nomi.cz> <4C894AE8.1010705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C894AE8.1010705@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 09, 2010 at 02:00:24PM -0700, H. Peter Anvin wrote:
> Could you give us your .config and also what version of gcc and binutils
> is on your system?

http://store.lisk.in/tmp/.config.2.6.32.21-debug

$ ld -V
GNU ld (GNU Binutils for Debian) 2.20.1-system.20100303

(that's 2.20.1-12 in Debian testing)

$ cc -dumpversion
4.4.5

(that's 4:4.4.4-2 in Debian testing)

$ cat /proc/version 
Linux version 2.6.36-rc3-lis-00187-ga784c32 (tomi@notes.lisk.in) (gcc version
4.4.5 20100728 (prerelease) (Debian 4.4.4-8) ) #103 SMP Thu Sep 9 16:40:09
CEST 2010

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
