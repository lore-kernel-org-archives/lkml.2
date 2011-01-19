Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1ASUBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:01:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1ASUBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:01:13 -0500
Date: Wed, 19 Jan 2011 21:01:06 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] BUG: unable to handle kernel paging request at fffba000
Message-ID: <20110119200106.GL9506@random.random>
References: <20110119124047.GA30274@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119124047.GA30274@kwango.lan.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for the report!

On Wed, Jan 19, 2011 at 02:40:47PM +0200, Ilya Dryomov wrote:
> Hello,
> 
> I just built a fresh 38-rc1 kernel with transparent huge page support
> built-in (TRANSPARENT_HUGEPAGE=y) and it failed to boot with the
> following bug.  However after the reboot everything went fine.  It turns
> out it only happens when fsck checks one or more filesystems before they
> are mounted.
> 
> It's easily reproducable it with touch /forcefsck and reboot on one of
> my 32-bit machines.  Haven't tried it on others yet.

Could you send me the vmlinux (or bzImage)? I can't see where it crash
otherwise.

Most certainly it's 32bit bug only.
