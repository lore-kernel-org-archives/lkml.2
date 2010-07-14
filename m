Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0GNIkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:40:05 -0400
Received: from mailhost-c5-p0.nerim.net ([195.5.209.11]:62790 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190Ab0GNIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:40:04 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 04:40:04 EDT
Date: Wed, 14 Jul 2010 10:31:12 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Zeno Davatz <zdavatz@gmail.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kmemleak, cpu usage jump out of nowhere
Message-ID: <20100714083112.GA4627@brouette>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
 <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
> > I got a new Intel core-8 i7 processor.

> > I am on kernel uname -a

> > Linux zenogentoo 2.6.35-rc5 #97 SMP Tue Jul 13 16:13:25 CEST 2010 i686
> > Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel GNU/Linux

> > Sometimes in the middle of nowhere all of a sudden all of my 8-cores
> > are at 100% CPU usage and my machine really lags and hangs and is not
> > useable anymore. Some random process just grabs a bunch CPUs according
> > to htop.

* Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-14 11:05]:
> Why did you enable CONFIG_DEBUG_KMEMLEAK? Memory leak scanning is
> likely the source of these pauses.

I am seeing the same problem with a Core i7 920 and 2.6.35-rc5, and I do
not have CONFIG_DEBUG_KMEMLEAK enabled, so I think this is not related.

I do not see anything special in the logs, just the load becoming mad
and almost preventing ssh access. I've been seeing that since the first
2.6.35 rc I tested (-rc2 or -rc3, I don't remember) and I did not have
time to report it before but I was surprised nobody else did. No problem
with 2.6.34 and 2.6.34.1.

-- 
Damien
