Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1EDLGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 07:06:52 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44875 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752539Ab1EDLGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 07:06:50 -0400
Date: Wed, 4 May 2011 12:02:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-cris-kernel@axis.com,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] atomic: add *_dec_not_zero
Message-ID: <20110504110207.GA4243@linux-mips.org>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:30:35PM +0200, Sven Eckelmann wrote:

>  arch/mips/include/asm/atomic.h     |    2 ++
>  arch/mips/include/asm/local.h      |    1 +

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
