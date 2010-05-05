Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab0EEUgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:36:12 -0400
Received: from lazybastard.de ([212.112.238.170]:36510 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326Ab0EEUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:36:08 -0400
Date: Wed, 5 May 2010 22:35:48 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, logfs@logfs.org
Subject: Re: linux-next: Tree for April 28 (logfs)
Message-ID: <20100505203548.GI25129@logfs.org>
References: <20100428164341.cee2911a.sfr@canb.auug.org.au> <20100428085604.0566092a.randy.dunlap@oracle.com> <20100505092020.66a461fa.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100505092020.66a461fa.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010 09:20:20 -0700, Randy Dunlap wrote:
> On Wed, 28 Apr 2010 08:56:04 -0700 Randy Dunlap wrote:
> 
> > When CONFIG_BLOCK is not enabled:
> > 
> > fs/logfs/super.c:142: error: implicit declaration of function 'bdev_get_queue'
> > fs/logfs/super.c:142: error: invalid type argument of '->' (have 'int')
> 
> Still have this build error in linux-next-May 5-2010.

Should be fixed now.  Sorry about the delay.

> [and L:      logfs@logfs.org
> is moderated for non-subscribers]

I have disabled the bounce mails.  Still moderated, but much less
annoying, I hope.

Jörn

-- 
Why do musicians compose symphonies and poets write poems?
They do it because life wouldn't have any meaning for them if they didn't.
That's why I draw cartoons.  It's my life.
-- Charles Shultz
