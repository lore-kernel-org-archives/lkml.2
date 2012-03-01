Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2CAI2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:28:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2CAI2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:28:19 -0500
Date: Thu, 1 Mar 2012 09:28:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: linux-next: manual merge of the trivial tree with the v4l-dvb
 tree
In-Reply-To: <20120229143359.e983bed880aded7b8f99b6bf@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1203010927080.23367@pobox.suse.cz>
References: <20120229143359.e983bed880aded7b8f99b6bf@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/media/video/s5p-tv/hdmi_drv.c due to commit 382d19f197f9 ("media:
> Fix typo in mixer_drv.c and hdmi_drv.c") from the trivial tree also
> already existing in the v4l-dvb tree (same patch different commit) (and
> there are further changes in that tree to this file).
> 
> I just the used the version from the v4l-dvb tree.

Reverted now in my tree, thanks.

-- 
Jiri Kosina
SUSE Labs
