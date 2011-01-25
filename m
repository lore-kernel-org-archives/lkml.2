Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1AYHDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:03:34 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45493 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1AYHDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:03:32 -0500
Date: Tue, 25 Jan 2011 16:03:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Yannick Heneault <yheneaul@matrox.com>,
        Matthew Garrett <mjg@redhat.com>, linux-fbdev@vger.kernel.org
Subject: Re: [Patch V2] video: fix some comments in drivers/video/console/vgacon.c
Message-ID: <20110125070324.GG11673@linux-sh.org>
References: <1295418242-19859-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295418242-19859-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:24:02PM +0800, Amerigo Wang wrote:
> Now vgacon_scrollback_startup() uses slab, not bootmem,
> the comment above it is obsolete, so does __init_refok.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
Applied, thanks.
