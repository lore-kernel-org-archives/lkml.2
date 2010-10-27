Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986Ab0J0LwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:52:13 -0400
Received: from verein.lst.de ([213.95.11.210]:49121 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab0J0LwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:52:12 -0400
Date: Wed, 27 Oct 2010 13:52:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: hch@tuxera.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] FS: hfsplus, fix lock imbalance
Message-ID: <20101027115206.GB26030@lst.de>
References: <1288180275-19941-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288180275-19941-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 01:51:15PM +0200, Jiri Slaby wrote:
> Stanse found that there is mutex_lock in a fail path of
> hfsplus_ioctl_setflags (i.e. double lock + leaving a function in
> locked state). So fix that.

Dan Carpenter already sent the same fix and I applied it.  I'll push it
out to Linus soon.

