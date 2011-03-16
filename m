Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1CPTvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:51:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46417 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1CPTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:51:37 -0400
Date: Wed, 16 Mar 2011 19:51:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] several fixes
Message-ID: <20110316195132.GV22723@ZenIV.linux.org.uk>
References: <20110316144253.GT22723@ZenIV.linux.org.uk>
 <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 06:17:54PM +0100, Miklos Szeredi wrote:
> On Wed, 16 Mar 2011, Al Viro wrote:
> > 	Several fixes, including the brown paperbag one for -ELOOP breakage
> > in the last commit of yesterday pull.  Please, pull from the usual place -
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
> 
> __fput doesn't need a cdev_put() for O_PATH handles.

Good catch, thanks.  Linus, do you want me to put that through vfs-2.6 or
would you rather apply directly?
