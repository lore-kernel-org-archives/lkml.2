Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2CRWkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 18:40:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36879 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab2CRWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 18:40:08 -0400
Date: Sun, 18 Mar 2012 22:40:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mike Marciniszyn <infinipath@qlogic.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: races in ipathfs
Message-ID: <20120318224007.GF6589@ZenIV.linux.org.uk>
References: <20120119202003.GZ23916@ZenIV.linux.org.uk>
 <20120318184547.GA6814@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120318184547.GA6814@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 06:45:47PM +0000, Al Viro wrote:
> On Thu, Jan 19, 2012 at 08:20:04PM +0000, Al Viro wrote:
> > 	Use of qib_super is seriously racy.  qibfs_add() (and worse,
> > qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().
> 
> [snip]
> 
> FWIW, I've put a completely untested patchset into
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git qibfs

Corresponding fix for ipathfs added to the same branch; again, completely
untested.
