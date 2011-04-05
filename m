Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1DECHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:07:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61387 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1DECHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Hv7g4XAByyFxs0oJy81RgO3IphXpdRvunxupFP4mMVSXSIpL49JY93LRwnMRvoE5Mw
         7RhrZGm0AV5wp/gOaIYvZeBNaQ5i5brok99cYrOGfjEz6w4ydssew0wSfQerhOpqpMVn
         pxI5gAAKfDMpXpHCxIsabYIVrcWwuFc1a0u4o=
Date: Tue, 5 Apr 2011 10:07:20 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
Message-ID: <20110405020717.GA2506@gmail.com>
Mail-Followup-To: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
	greg@kroah.com, akpm@linux-foundation.org
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
 <20110403045201.GA2598@gmail.com>
 <4D99230C.6040403@cn.fujitsu.com>
 <20110404111829.af8bc108.rdunlap@xenotime.net>
 <BANLkTinSC1UTEQxS0iCKu4tMX-9CUY3rJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinSC1UTEQxS0iCKu4tMX-9CUY3rJg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 09:59:55AM +0800, harryxiyou wrote:
> On Tue, Apr 5, 2011 at 2:18 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > On Mon, 04 Apr 2011 09:46:52 +0800 Li Zefan wrote:
> >
> > > > Your updated link for HOWTO is just for linux-2.6.38. This link
> > > > should be up-to-date kernel code. So i have corrected your
> > > > patch like following.
> > > >
> > > > Thanks.
> > > > Best Regards.
> > > > Harry Wei.
> > > >
> > > > Signed-off-by: Someone Something <fordhaivat@gmail.com>
> > > > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > >
> > > Did he sign the patch? If not, you can't do this, and Instead you
> > > must ask him for his SOB.
> > >
> > > And I'll appreciate if you add:
> > >
> > >       From: Someone ...
> > >
> > > because your change is not significant enough to make you the author
> > > of the patch.
> >
> > Regardless of that latter part, we cannot merge the patch from SS,
> > like Xiaochen Wang said, since the name is false.
Hi Randy,
    I have corrected this patch like following. This may be well 
for us.

Thanks.
BR.
Harry Wei.

From: Someone Something <fordhaivat@gmail.com>
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 Documentation/HOWTO |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 365bda9..81bc1a9 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -209,7 +209,7 @@ tools.  One such tool that is particularly recommended is the Linux
 Cross-Reference project, which is able to present source code in a
 self-referential, indexed webpage format. An excellent up-to-date
 repository of the kernel code may be found at:
-	http://users.sosdg.org/~qiyong/lxr/
+	http://lxr.linux.no/+trees
 
 
 The development process
-- 
1.7.0.4

