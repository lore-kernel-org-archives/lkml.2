Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab1LGE74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 23:59:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56280 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab1LGE7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 23:59:54 -0500
Date: Wed, 7 Dec 2011 04:59:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207045952.GZ2203@ZenIV.linux.org.uk>
References: <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <4EDED96E.7000106@canonical.com>
 <4EDEEAE1.2060304@canonical.com>
 <20111207044510.GY2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207044510.GY2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:45:10AM +0000, Al Viro wrote:
> On Tue, Dec 06, 2011 at 08:26:09PM -0800, John Johansen wrote:
> 
> > Reviewed-by: John Johansen <john.johansen@canonical.com>
> 
> Umm... assuming that's an ACK, the damn thing is in
> git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> 
> Linus, could you pull it?

OK, explicit ACKed-by confirmed, added to commit and pushed.
