Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1GaFrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:47:45 -0400
Received: from msr1.hinet.net ([168.95.4.101]:39448 "EHLO msr1.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab1GaFrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:47:37 -0400
X-Greylist: delayed 7128 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jul 2011 01:47:36 EDT
Date: Sun, 31 Jul 2011 11:45:59 +0800
From: Ali Bahar <ali@internetdog.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 1.5
Message-ID: <20110731034559.GA8041@internetdog.org>
Reply-To: ali@internetdog.org
Mail-Followup-To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
 <20110726033535.GA11939@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110726033535.GA11939@x4.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 05:35:35AM +0200, Markus Trippelsdorf wrote:
> On 2011.07.25 at 19:56 +0100, Al Viro wrote:
> > Regression fixes (devtmpfs race, cifs ->d_revalidate() breakage, fsync
> > fallout), ACL stuff (me/Linus/Christoph), fixes for bugs found while
> 
> > Linus Torvalds (1):
> >       vfs: move ACL cache lookup into generic code
> 
> This breaks the build for "# CONFIG_FS_POSIX_ACL is not set" configs:
> 
>   CC      fs/namei.o
> fs/namei.c: In function ‘check_acl’:
> fs/namei.c:191:10: error: implicit declaration of function ‘negative_cached_acl’ [-Werror=implicit-function-declaration]
> fs/namei.c:196:2: error: implicit declaration of function ‘get_cached_acl’ [-Werror=implicit-function-declaration]
> fs/namei.c:196:6: warning: assignment makes pointer from integer without a cast [enabled by default]
> fs/namei.c:212:11: error: implicit declaration of function ‘set_cached_acl’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Ditto.
(I'm using the staging-2.6 tree.)
regards,
ali

> 
> -- 
> Markus
