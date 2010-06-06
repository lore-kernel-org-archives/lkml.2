Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034Ab0FFPkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:40:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47981 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0FFPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:40:51 -0400
Date: Sun, 6 Jun 2010 16:40:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: 2.6.35-rc2 : OOPS with LTP memcg regression test run.
Message-ID: <20100606154048.GJ31073@ZenIV.linux.org.uk>
References: <4C0BB98E.9030101@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0BB98E.9030101@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 08:36:54PM +0530, Sachin Sant wrote:

> And few more of these. Previous snapshot release 2.6.35-rc1-git5(6c5de280b6...)
> was good.

That's very odd, since
; git diff --stat 6c5de280b6..v2.6.35-rc2         
 Makefile                             |    2 +-
 drivers/gpu/drm/i915/intel_display.c |    9 +++++++
 fs/ext4/inode.c                      |   40 +++++++++++++++++++--------------
 fs/ext4/move_extent.c                |    3 ++
 4 files changed, 36 insertions(+), 18 deletions(-)
;
and nothing of that looks like good candidates...
