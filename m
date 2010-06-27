Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0F0Qjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 12:39:52 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:6204 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab0F0Qjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 12:39:51 -0400
Message-ID: <4C277ED5.6020208@tilera.com>
Date: Sun, 27 Jun 2010 12:39:49 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Miscellaneous cleanup changes.
References: <201006252110.o5PLArqD010774@farm-0002.internal.tilera.com> <201006261156.28495.arnd@arndb.de>
In-Reply-To: <201006261156.28495.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/2010 5:56 AM, Arnd Bergmann wrote:
> As far as I can tell, all the changes in this patch look reasonable, but
> as a rule you should never mix functional changes and cleanups in a single
> patch. This is both for review purposes as well as for being able to bisect
> specific regressions that might be introduced by the patch.
>   

Yes, I'll try to be more precise with my commits in the future.  I was
playing catch-up with a bunch of commits in our internal tree, which
uses Perforce.  The change migration process doesn't lend itself to
pulling individual commits out of Perforce and into git, and I also
worried about spamming LKML with dozens of small patches for the tile
architecture, which after all hasn't even been pulled into Linus's tree
yet.  And, of course, since few if any folks are actually running these
bits on their hardware yet (our hardware customers are likely all
running the sources we ship them), the bisection issue is less
critical.  But I will at least make sure to separate out cleanups and
bugfixes going forward.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

