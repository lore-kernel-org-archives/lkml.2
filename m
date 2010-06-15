Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0FOAsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:48:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41599 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0FOAsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:48:10 -0400
Date: Mon, 14 Jun 2010 20:47:35 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Message-ID: <20100615004735.GR18266@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Ed Tomlinson <edt@aei.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20100611193731.GA3018@think>
 <201006141524.20752.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006141524.20752.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C16CDC7.022F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 03:24:19PM -0400, Ed Tomlinson wrote:
> On Friday 11 June 2010 15:37:31 Chris Mason wrote:
> > Hello everyone,
> > 
> > The master branch of the btrfs-unstable tree is a collection of fixes
> > and cleanups, including two btrfs regressions from rc1:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> > 
> > One is an freeing blocks on an FS converted from ext34 to btrfs,
> > and the other is a fallocate fix.
> > 
> > The rest are the usual small bug fixes.
> 
> Looks like this still misses any fix for the oops I reported May 8th in thread:
> "[OPPS] btrfs on 33-3 with latest from btrfs-unstable.git master"
> 
> Any chance this could be looked into?  I've kept the fs just in case.

The oops shows a crc failure and then we were not able to read the tree
block.  Yan Zheng is working on an fsck that can repair things now.
Until then the best I can do is help copy things off.

Would you rather save the FS to test fsck?

-chris
