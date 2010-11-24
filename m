Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0KXNC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:02:29 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:55192 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab0KXNC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:02:26 -0500
Date: Wed, 24 Nov 2010 12:54:12 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Andreas Schwab <schwab@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-mips@linux-mips.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH v3 22/22] bitops: remove minix bitops from asm/bitops.h
Message-ID: <20101124125412.GA1876@linux-mips.org>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
 <1290519504-3958-23-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290519504-3958-23-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 10:38:24PM +0900, Akinobu Mita wrote:

> minix bit operations are only used by minix filesystem and useless
> by other modules. Because byte order of inode and block bitmaps is
> defferent on each architecture like below:
  ^^^^^ different

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
