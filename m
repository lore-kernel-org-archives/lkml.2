Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1GNIKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:10:41 -0400
Received: from emaiti.net ([46.4.199.113]:52621 "EHLO mail.emaiti.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab1GNIKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:10:39 -0400
X-Greylist: delayed 1246 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jul 2011 04:10:39 EDT
Date: Thu, 14 Jul 2011 09:50:07 +0200
From: Francesco Allertsen <fallertsen@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reverting rc6 by default
Message-ID: <20110714075007.GB2949@fujiko>
References: <20110621155205.GA2488@fujiko>
 <yunboxrxiz2.fsf@aiko.keithp.com>
 <20110621164209.GA2155@fujiko>
 <yun8vsvxdr4.fsf@aiko.keithp.com>
 <20110621184757.GA2185@fujiko>
 <yunzklb9fg1.fsf@aiko.keithp.com>
 <20110705230101.GD2852@fujiko>
 <CAOJsxLFVSEDEaYH8Dw4jWGo9=wkC8QQWOs4xRR6qcgVM2xCRoA@mail.gmail.com>
 <yunhb6rec97.fsf@aiko.keithp.com>
 <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGKtjCpY=X1UrHVY79qLjVCgCT3XC795yh_uEn-0_4D0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 10:37:15AM +0300, Pekka Enberg wrote:
> This if fixed in mainline as of commit
> a94919eaddaa3fede1df8563ce4d761a75374645 ("Revert "drm/i915: enable
> rc6 by default"). Keith, it would have been nice to include a
> 'Reported-by' and/or a link to this discussion in the changelog for
> future reference.

The correct commit is 05bd42688dbc066d4e2689b6f73c0470601f788b, the one
you mentioned is "Idling requires waiting for the ring to be empty".

Bye
Francesco
