Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0E2L3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 07:29:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0E2L3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 07:29:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 0/8] revised patch for arch/tile/ support
Date: Sat, 29 May 2010 13:29:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005290333.o4T3Xjse029917@farm-0002.internal.tilera.com>
In-Reply-To: <201005290333.o4T3Xjse029917@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005291329.10941.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+TicHXPTHd3hNBcmGK6VYWHooI4KRg+u63u7C
 3qPlgsmjJw2LwBwOteL+FLBYxrgSlfqBr/NykkJnqAQOeuZqDq
 O2npzXK0OIQlcCmDWvUZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010, Chris Metcalf wrote:
> On May 20 I wrote:
> > At Tilera we have been running Linux 2.6.26 on our architecture for a
> > while and distributing the sources to our customers.  We just sync'ed up
> > our sources to 2.6.34 and would like to return it to the community more
> > widely, so I'm hoping to take advantage of the merge window for 2.6.35
> > to integrate support for our architecture.
> 
> Thanks to some much-appreciated volunteer work reviewing that initial
> patch, I now have a revised set of patches which I would like to offer
> for submission to the mainline.

It seems that you have addressed all my review comments and all the
other comments that I have seen in the best possible ways.
All the controversial parts from the original code are either corrected
or (in case of nonessential drivers) deferred to a future review.
I did not expect this to be possibly in such a short time, and it
continues to amaze me.

Consequently, I fully support this series to go into 2.6.35.
To the entire series:

Acked-by: Arnd Bergmann <arnd@arndb.de>
