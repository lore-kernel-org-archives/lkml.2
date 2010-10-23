Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0JWBhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 21:37:24 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:37284 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab0JWBhX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 21:37:23 -0400
Date: Sat, 23 Oct 2010 02:07:17 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gene Heskett <gene.heskett@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36, make oldconfig broken
Message-ID: <20101023010717.GA20750@deepthought>
References: <201010221229.36996.gene.heskett@gmail.com> <20101022114019.60839ff2.randy.dunlap@oracle.com> <201010221608.36754.gene.heskett@gmail.com> <4CC20011.5010809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4CC20011.5010809@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=0apVwtOf9NkA:10 a=8nJEP1OIZ-IA:10 a=YWANvCmmTlRy2eSb6ukA:9 a=HVBQhIOTAhX0kkC9Ixo29iezgqQA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:20:17PM -0700, Randy Dunlap wrote:
> On 10/22/10 13:08, Gene Heskett wrote:
> > 
> > But I'll be interested in what you get.  Its stuff like this that have made 
> > me wary of downloading the kernel images in .bz2 formats, too many times I 
> > have had to go back and get the .gz version because the unpacking of the 
> > .bz2 upchucked and silently threw away a subdir tree, and only a fresh 
> > download fixes it, blowing it away and unpacking the bz2 again will only fix 
> > it occasionally.  I started with the tar.gz of course this time.
> 
> Curiouser and curiouser.
> I always download & build from .bz2 tarballs, with no problems.
> 
 On my own x86 machines, I can remember seeing apparently corrupted
.tar.bz2 files twice in the last eight-or-so years.  In each case,
untarring reported an error, it didn't silently lose files and
directories, and in each case the problem was failing memory.

 In Gene's case, I recommend running memtest86 or better ('+') as
soon as possible.  On my problematic x86 boxes, memtest86 started to
report errors within a minute or so of starting.  If it runs for a
whole cycle, the memory is probably ok.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
