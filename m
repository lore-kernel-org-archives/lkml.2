Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1APVV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:21:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45729 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1APVVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:21:55 -0500
Message-ID: <4D33608F.6060908@zytor.com>
Date: Sun, 16 Jan 2011 13:18:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Bryan Wu <bryan.wu@analog.com>, Mikael Starvik <starvik@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Luck, Tony" <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <willy@debian.org>,
        Grant Grundler <grundler@parisc-linux.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Kazumoto Kojima <kkojima@rr.iij4u.or.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 09/24] bitops: introduce little-endian bitops for most
 architectures
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com> <1295183333-13802-10-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1295183333-13802-10-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2011 05:08 AM, Akinobu Mita wrote:
> Introduce little-endian bit operations to the architectures which do not
> have native little-endian bit operations.  (alpha, avr32, blackfin, cris,
> frv, h8300, ia64, m32r, mips, mn10300, parisc, sh, sparc, tile, x86,
> xtensa)
> 
> These architectures can just include generic implementation
> (asm-generic/bitops/le.h).
> 

ACK on the patch, but the description is confusing for actual
littleendian architectures -- the native bit operations on x86, for
example, are in fact littleendian (and as such <asm-generic/bitops/le.h>
just wraps the existing native bitops.)

	-hpa
