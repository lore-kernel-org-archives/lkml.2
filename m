Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0G2L5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:57:45 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:63123 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab0G2L5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:57:44 -0400
Date: Thu, 29 Jul 2010 13:57:43 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
Message-ID: <20100729115743.GB13192@faui48a.informatik.uni-erlangen.de>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 07:26:00PM +0800, Américo Wang wrote:
> On Thu, Jul 29, 2010 at 6:52 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
> > Hi all!
> >
> >    Building the linux kernel, as well as doing a"make allyesconfig"
> > on a fresh checkout of linux HEAD results in the same Bus Error in
> > fixdep (details below). This is a i5 box running 32bit Ubuntu Lucid
> > with plenty of (free) RAM. Haven't found any hints to what might be
> > wrong on scanning over the web archives.
> >
> > Regards
> >
> >    Christoph
> >
> > -----
> >  % make allyesconfig
> >  HOSTCC  scripts/basic/fixdep
> > fixdep: mmap: Cannot allocate memory
> 
> So what does 'ls -lh scripts/basic/.fixdep.d' say?
> Seems this file is too big...

% ls -lh scripts/basic/.fixdep.d
-rw-r--r-- 1 siccegge immdstud 2.4K 2010-07-29 12:51 scripts/basic/.fixdep.d

Doesn't really look that big to me
