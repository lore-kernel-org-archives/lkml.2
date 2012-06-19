Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2FSQz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:55:26 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:25105 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab2FSQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:55:25 -0400
Date: Tue, 19 Jun 2012 17:55:20 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Message-ID: <20120619165520.GA11015@milliways>
References: <20120618141854.GA7962@milliways>
 <1340031234.2451.13.camel@lade.trondhjem.org>
 <20120618160005.GA10169@milliways>
 <20120618200525.GA15654@milliways>
 <20120618215323.GA17561@milliways>
 <1340057002.20570.31.camel@lade.trondhjem.org>
 <20120618221052.GA18341@milliways>
 <20120619010641.GA22288@milliways>
 <1340122836.3754.9.camel@lade.trondhjem.org>
 <1340123001.3754.11.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340123001.3754.11.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=wom5GMh1gUkA:10 a=3oYqF3-p60YA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=p3dJRxHdGEICCuda0cQA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:23:23PM +0000, Myklebust, Trond wrote:
> On Tue, 2012-06-19 at 12:20 -0400, Trond Myklebust wrote:
> > 
> > However you are saying that the problem is there when you compile a
> > kernel with this commit as the head, and it goes away when you compile a
> > kernel with commit 3e9e0ca3f19e911ce13c2e6c9858fcb41a37496c as the head?
> > 
 Provided I apply 4f97615d as well, so that it compiles, yes.

> > I'm confused as to how a bug in that patch could depend on
> > CONFIG_NFS_V4, but I'll see what I can find.

 Thanks
> 
> By the way, I thought your test-case was doing firefox downloads. Do
> those really use O_DIRECT?
> 
 I originally saw the problem doing that, but it was on the second
download.  Or perhaps third or fourth - I tend not to remember
successful downloads when I've got a lot of packages to check for new
versions.  Using my backup script seemed a more reliable way to
trigger a problem (but, only if there is something substantial to
back up, such as a new vmlinuz).

 Thinking about this, it is almost certain that between the first
download and the one that failed (several hours later) my backup
script did run, from fcron, so I now think the rsync problem is what
leads to issues when other programs later try to update the same nfs
directory.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
