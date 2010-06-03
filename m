Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0FCUlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:41:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0FCUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:40:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 0/8] revised patch for arch/tile/ support
Date: Thu, 3 Jun 2010 22:40:31 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005290333.o4T3Xjse029917@farm-0002.internal.tilera.com> <201005291329.10941.arnd@arndb.de>
In-Reply-To: <201005291329.10941.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006032240.31963.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+wM7a2DjiVRp9qUGNUoAEDXlAHF8HxUchxG4F
 /tHhI+r3Z0Vx0O6C/IbbGzJlNVmn+5cZRzWEQEW7CEj+3DvMFr
 dEUOlL5r0DTmFZPqZjdeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010 13:29:10 Arnd Bergmann wrote:
> On Saturday 29 May 2010, Chris Metcalf wrote:
> > 
> > Thanks to some much-appreciated volunteer work reviewing that initial
> > patch, I now have a revised set of patches which I would like to offer
> > for submission to the mainline.
> 
> It seems that you have addressed all my review comments and all the
> other comments that I have seen in the best possible ways.
> All the controversial parts from the original code are either corrected
> or (in case of nonessential drivers) deferred to a future review.
> I did not expect this to be possibly in such a short time, and it
> continues to amaze me.
> 
> Consequently, I fully support this series to go into 2.6.35.
> To the entire series:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Hi Chris,

You evidently didn't make it into -rc1, probably because Linus considered
your submission to be too late, or possibly because some of the bigger
patches got lost in an email filter.

To go forward with your architecture, I suggest that you start adding it
to the linux-next tree. Until you have a git tree, the easiest way
to do that is to put a tarball in quilt format at a http url under
your control, and ask Stephen to include that.

Feel free to add a 'Reviewed-by: Arnd Bergmann <arnd@arndb.de>' to your
existing patches, and do your further work as patches on top of that.

	Arnd
