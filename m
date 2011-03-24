Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306Ab1CXWlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:41:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52773 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309Ab1CXWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:40:58 -0400
Date: Thu, 24 Mar 2011 22:40:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: sedat.dilek@gmail.com
Cc: Valerie Aurora <valerie.aurora@gmail.com>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, hch@lst.de,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 00/74] Union mounts version something or other
Message-ID: <20110324224047.GN2356@decadent.org.uk>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
 <AANLkTinnRz2PPc3XqgCK72S9+fqTK0QCUOLkK98S5j_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinnRz2PPc3XqgCK72S9+fqTK0QCUOLkK98S5j_Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.i.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:38:39AM +0100, Sedat Dilek wrote:
[...]
> Whuzzz up with AUFS?
> Even there where massive changes to VFS and FS in 2.6.38+, there is an
> adapted kernel patch around (for example see Debian's 2.6.38 linux-2.6
> packages in experimental branch).

Do not cite the Debian kernel team as supporting aufs.  It is included
only because Debian Live needs some kind of union filesystem, and only
until that appears in-tree.

> From my POV OverlayFS is the new star at the skyline and should be
> promoted as 1st choice, now.
[...]

This thread is for technical review, not marketing.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
