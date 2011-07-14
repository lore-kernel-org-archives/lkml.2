Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1GNRAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:00:14 -0400
Received: from emaiti.net ([46.4.199.113]:46965 "EHLO mail.emaiti.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab1GNRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:00:13 -0400
Date: Thu, 14 Jul 2011 19:00:26 +0200
From: Francesco Allertsen <fallertsen@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Pekka Enberg <penberg@kernel.org>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reverting rc6 by default
Message-ID: <20110714170026.GA2261@fujiko>
References: <20110621164209.GA2155@fujiko>
 <yun8vsvxdr4.fsf@aiko.keithp.com>
 <20110621184757.GA2185@fujiko>
 <yunzklb9fg1.fsf@aiko.keithp.com>
 <20110705230101.GD2852@fujiko>
 <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com>
 <yunhb6rec97.fsf@aiko.keithp.com>
 <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com>
 <20110714075007.GB2949@fujiko>
 <yuntyaohmo3.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yuntyaohmo3.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:06:20AM -0700, Keith Packard wrote:
> We mentioned the 'Idling' fix as it may make RC6 work. Have you tried
> that with RC6 enabled on the command line (or with
> 05bd42688dbc066d4e2689b6f73c0470601f788b not applied)? Obviously, not
> enabling RC6 by default will 'fix' things, but only with a huge hit to
> power consumption.

I have tried to boot with the latest git with the commit
05bd42688dbc066d4e2689b6f73c0470601f788b reverted (so I have the 'Idling
fix' and the rc6 enabled), but I have the same freeze.

Bye
Francesco
