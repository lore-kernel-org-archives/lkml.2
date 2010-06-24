Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0FXJuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:50:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:40570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab0FXJuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:50:21 -0400
Subject: RE: Btrfs: broken file system design (was Unbound(?) internal 
 fragmentation in Btrfs)
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Mat <jackdachef@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       The development of BTRFS <linux-btrfs@vger.kernel.org>
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
References: <4C07C321.8010000@redhat.com>
	 <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
	 <4C1B7560.1000806@gmail.com>
	 <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
	 <4C1BA3E5.7020400@gmail.com> <20100623234031.GF7058@shareable.org>
	 <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 10:50:13 +0100
Message-ID: <1277373013.21395.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 20:43 -0700, Daniel Taylor wrote:
> There is also the issue of btrfs over RAID (which I know is not
> entirely sensible, but which will happen). 

Well, we could discourage that by merging the RAID support that's been
pending for a while.... but I suspect Chris is a bit busy right now :)

-- 
dwmw2

