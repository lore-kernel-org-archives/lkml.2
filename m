Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab0GEOxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 10:53:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab0GEOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 10:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gUy9xZpL30muGneg6m4+jo9B/8JJcm8580oQDqPcsPzG0Q/wlo39QNWe2CZU/q4nuf
         kaDVb22ICKWVfZzN5EXtoJfkDNCwwLa12vhPzqHV86mna2qoG+SoN5unIf+qeSjW6o1k
         OER/cYb2uxtKiL+sIVKsTYk0xRlHYuFzh1k9E=
Date: Mon, 5 Jul 2010 16:53:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] nilfs2: remove BKL uses
Message-ID: <20100705145324.GA5240@nowhere>
References: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <201007051650.23761.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007051650.23761.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 04:50:23PM +0200, Arnd Bergmann wrote:
> On Sunday 04 July 2010, Ryusuke Konishi wrote:
> > Nilfs has BKL uses in its put_super and remount functions, but none of
> > them are necessary, just came from earlier push downs.  This
> > eliminates the BKL uses from nilfs.
> > 
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> 
> This looks good, but there is a another patch series pushing the BKL
> into the get_sb and fill_super operations, which should be the final
> pushdown for file systems. I wonder if there is a way to find a
> shortcut on this so we don't need to add it first just to have you
> go through the effort of removing it again.


I could take his patch in the mount pushdown series.

