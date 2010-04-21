Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0DUXfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:35:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab0DUXfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:35:40 -0400
Date: Wed, 21 Apr 2010 19:35:36 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/35] Union mounts - everything but the xattrs
Message-ID: <20100421233536.GB27926@shell>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com> <20100421150634.1f01240a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421150634.1f01240a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 03:06:34PM -0700, Randy Dunlap wrote:
> On Thu, 15 Apr 2010 16:04:07 -0700 Valerie Aurora wrote:
> 
> > This patch series implements union mounts for every system call
> > except:
> > 
> > - xattr-related calls
> > - fchmod()/fchown()/futimensat() on an fd
> > 
> > The copyup portion is a proof of concept based around union_path_nd(),
> > which looks up both the target <mnt,dentry> pair and its parent's.  If
> > the parent is on a union mount, and the target is on a lower layer, we
> > copy up the target.
> > 
> > This patch set is very raw and could use even the most superficial
> > review.  Just take a look at Erez's review from December to see how
> > low-hanging the fruit is on this one.
> > 
> > -VAL
> 
> 
> Hi VAL,
> 
> In the future, please make patches 1-N reply/refer to patch 0 instead of to
> the preceding numbered patch.

Okay.

-VAL
