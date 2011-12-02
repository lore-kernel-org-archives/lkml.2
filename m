Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1LBOia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:38:30 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64675 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751Ab1LBOi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:38:29 -0500
Message-ID: <1322836693.3780.7.camel@lappy>
Subject: Re: [PATCH 1/1] hv: Update MAINTAINERS
From: Sasha Levin <levinsasha928@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 02 Dec 2011 16:38:13 +0200
In-Reply-To: <alpine.LNX.2.00.1112021531230.18207@pobox.suse.cz>
References: <1322778690-17381-1-git-send-email-kys@microsoft.com>
	 <alpine.LNX.2.00.1112021531230.18207@pobox.suse.cz>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 15:31 +0100, Jiri Kosina wrote:
> On Thu, 1 Dec 2011, K. Y. Srinivasan wrote:
> 
> > Update the MAINTAINERS file to reflect the current state
> > of the Hyper-V drivers.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  MAINTAINERS |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3523ab0..809cad8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3197,6 +3197,16 @@ M:	William Irwin <wli@holomorphy.com>
> >  S:	Maintained
> >  F:	fs/hugetlbfs/
> >  
> > +Hyper-V CORE AND DRIVERS
> > +M:	K. Y. Srinivasan <kys@microsoft.com>
> > +M:	Haiyang Zhang <haiyangz@microsoft.com>
> > +L:	devel@linuxdriverproject.org
> > +S:	Maintained
> > +F:	drivers/hv/
> > +F:	drivers/hid/hid-hyperv.c
> > +F:	drivers/net/hyperv/
> > +F:	drivers/staging/hv/
> > +
> 
> I will be taking this through trivial tree. Thanks,

It should probably be 'S: Supported' though, right?

-- 

Sasha.

