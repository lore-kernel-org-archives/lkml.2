Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab2ACLQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 06:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab2ACLQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 06:16:35 -0500
Subject: Re: linux-next: Tree for Dec 28 (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com, David Teigland <teigland@redhat.com>
In-Reply-To: <4EFB859F.7000707@xenotime.net>
References: <20111228201806.d6de27fa2dbd9e3a3b7a2603@canb.auug.org.au>
	 <4EFB859F.7000707@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 03 Jan 2012 11:17:24 +0000
Message-ID: <1325589444.2685.25.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-12-28 at 13:09 -0800, Randy Dunlap wrote:
> On 12/28/2011 01:18 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > I got bored :-(  I also hate tree wide, flag day changes :-(
> > 
> > Changes since 20111222:
> 
> 
> modular:
> ERROR: "gfs2_control_wq" [fs/gfs2/gfs2.ko] undefined!
> 
> or builtin:
> main.c:(.init.text+0x313b): undefined reference to `gfs2_control_wq'
> main.c:(.exit.text+0x6a2): undefined reference to `gfs2_control_wq'
> 
> 
> 
> Modular randconfig file is attached.
> 
> 
I think that might be a mistake in the dlm -next tree. The patch in
question is in the dlm tree only because that is where the prerequisites
are also. However the patch (the final one in a series of mostly dlm
related patches) is still under review, even though the prior patches
are all ready,

Steve.


