Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2E3DkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:40:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45439 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2E3DkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:40:14 -0400
Date: Wed, 30 May 2012 04:40:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Luk?? Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mbroz@redhat.com
Subject: Re: [PATCH 1/2] vfs: Do not allow mnt_longterm to go negative
Message-ID: <20120530034011.GU11775@ZenIV.linux.org.uk>
References: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1205290807350.2144@dhcp-1-248.brq.redhat.com>
 <20120530020134.GA20448@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530020134.GA20448@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:01:34AM +0100, Al Viro wrote:

> Fixed in my tree, will push in a couple of hours.  And that'll need to
> go into -stable as well.  Thanks for catching that sucker...

OK, pushed into for-next, along with a bunch of other misc stuff; _NOT_
all that will be there.  If it survives a bit of beating in -next, to
Linus it goes.

Next pile to go in there is Miklos' stuff.
