Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1EDR1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:27:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49129 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524Ab1EDR1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:27:41 -0400
Subject: Re: [PATCH] atomic: add *_dec_not_zero
From: Will Deacon <will.deacon@arm.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-m32r@ml.linux-m32r.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, x86@kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 18:27:36 +0100
Message-ID: <1304530056.2296.1.camel@craptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 22:30 +0100, Sven Eckelmann wrote:
> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.
> 
For the ARM changes:

Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will


