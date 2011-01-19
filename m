Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1ASGFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:05:19 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47177 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1ASGFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:05:17 -0500
Date: Wed, 19 Jan 2011 15:02:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Yannick Heneault <yheneaul@matrox.com>,
        Matthew Garrett <mjg@redhat.com>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Subject: Re: [Patch] video: remove pointless comments in drivers/video/console/vgacon.c
Message-ID: <20110119060257.GA12205@linux-sh.org>
References: <1295416803-17651-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295416803-17651-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:00:02PM +0800, Amerigo Wang wrote:
> Now vgacon_scrollback_startup() uses slab, not bootmem,
> so that comment is obsolete, the rest are useless.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
If you're going to do this then at least follow through and do the rest
of it. The comment is no longer applicable, but then neither is the
__init_refok annotation. Killing off the comment explaining why something
is (or was there) without killing off the thing that is referenced by the
comment is not terribly productive.
