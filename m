Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2KWWeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 17:34:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50578 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2KWWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 17:34:18 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Nov 2012 22:33:57 +0000
X-Google-Sender-Auth: w7ZsUuKKlrL1KxvFCrSDMjtnN1o
Message-ID: <CACxGe6v-VAEDnOYtnRaYtNf_3njjbN4ZG42h6uPXO=VUJsn7-g@mail.gmail.com>
Subject: [GIT PULL] devicetree fix for v3.7
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        David Miller <davem@davemloft.net>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's is a device tree build regression fix that I've just received.
Please pull.

Thanks,
g.

The following changes since commit 26d29d06ea020411559f75ec908db235ca1838d9:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2012-11-22
21:45:34 -1000)

are available in the git repository at:


  git://git.secretlab.ca/git/linux-2.6 tags/devicetree-for-linus

for you to fetch changes up to 0e622d39197f0b64b9e043fe75ac3634bf9f3a05:

  of/address: sparc: Declare of_iomap as an extern function for sparc
again (2012-11-23 22:01:15 +0000)

----------------------------------------------------------------
Device tree regression fix for v3.7

Simple build regression fix for DT device drivers on Sparc. An earlier
change had masked out the of_iomap() helper on SPARC.

----------------------------------------------------------------
Andreas Larsson (1):
      of/address: sparc: Declare of_iomap as an extern function for sparc again

 arch/sparc/include/asm/prom.h |    5 ++++-
 include/linux/of_address.h    |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
