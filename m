Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2JAWX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:23:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab2JAWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:23:55 -0400
Date: Tue, 2 Oct 2012 00:23:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the hid
 tree
In-Reply-To: <20120821135832.4788b9d64fea34502cca895a@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1210020021570.23544@pobox.suse.cz>
References: <20120821135832.4788b9d64fea34502cca895a@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Stephen Rothwell wrote:

> Hi Tejun,
> 
> Today's linux-next merge of the workqueues tree got a conflict in
> drivers/hid/hid-picolcd.c between commit fabdbf2fd22f ("HID: picoLCD:
> split driver code") from the hid tree and commit 43829731dd37
> ("workqueue: deprecate flush[_delayed]_work_sync()") from the workqueues
> tree.
> 
> The former commit moved the code changed by the latter into a new file
> (and removed the old file) and then a later commit removed the call to
> flush_work_sync().  I just removed the file.

The same here. My part is now in Linus' tree -- Tejun, could you please 
sort this out on your side?

Thanks a lot,

-- 
Jiri Kosina
SUSE Labs
