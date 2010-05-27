Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0E0PDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:03:37 -0400
Received: from king.tilera.com ([72.1.168.226]:37745 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0E0PDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:03:35 -0400
Message-ID: <4BFE89C3.7000500@tilera.com>
Date: Thu, 27 May 2010 11:03:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005271041.30519.arnd@arndb.de> <4BFE73DF.5090107@tilera.com> <201005271611.47963.arnd@arndb.de>
In-Reply-To: <201005271611.47963.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 15:03:32.0436 (UTC) FILETIME=[C5DEC140:01CAFDAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/2010 10:11 AM, Arnd Bergmann wrote:
> You're right that any commit should result in something that's buildable.
> In this case I think you can make an exception because before the first
> patch, nothing builds in arch/tile, so you extend that phase to two
> or three patches before you get to the first one that's actually
> compilable.
>   

OK, will do.  I'm also planning to do a hard git reset to remove the
original patch, since much of it is no longer wanted anyway.  I'll mail
out a diff of what has changed relative to that original submission as
just a regular "diff -ru" so previous reviewers can see what has changed.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


