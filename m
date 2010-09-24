Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab0IXNda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:33:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0IXNd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:33:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: situation with signals
Date: Fri, 24 Sep 2010 15:33:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100923221141.GK19804@ZenIV.linux.org.uk>
In-Reply-To: <20100923221141.GK19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241533.23331.arnd@arndb.de>
X-Provags-ID: V02:K0:UGEm8NhKGTW2uaEhWR2YyQX544xpq1Ke144TLA9xJQE
 vplUlHoM+viP7YLAw0opGfrFqmCMSbof5z9TOP2hf7EOsOSKRz
 Nm5OOeqzgSuILGyTVNXiWX6lui6vAfeo4ujJJwRoa/gDF8Yobc
 1TBv0I+yaHkWJBV3JU7KKU0mgkQq2FCHia3vId4azKm1APnAa5
 8+CaqxQNoe9EViB9rKnKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010, Al Viro wrote:
>         There are several interesting issues in arch/*/*/*signal* (besides
> shoggoths starting to show up when one reads that code) and I'd been crawling
> through that area for the last few weeks.  Here are more or less common
> issues; there are really arch-specific bugs (e.g. roothole on frv that
> used to allow reading kernel memory by setting the right sa_handler), but
> that's a separate story.

I still plan to make a counterpart to the asm-generic headers with an
example architecture that new architectures can copy from. Signal handling
is one of the areas that I have very limited understanding of. Did you
encounter any architecture that basically gets signal handling right and that
can serve as a positive example to others?

arch/tile/kernel/signal.c was the last one that got merged and I tried
to direct the maintainer in the right direction as much as I could, but
there are a lot of things I didn't know about.

	Arnd
