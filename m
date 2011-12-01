Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1LAUEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:04:12 -0500
Received: from twin.jikos.cz ([89.185.236.188]:58600 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab1LAUEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:04:11 -0500
X-Greylist: delayed 1245 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 15:04:10 EST
Date: Thu, 1 Dec 2011 20:42:50 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Greg KH <greg@kroah.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: linux-next: manual merge of the staging tree with the hid tree
In-Reply-To: <20111201183956.GA32559@kroah.com>
Message-ID: <alpine.LRH.2.00.1112012042360.28290@twin.jikos.cz>
References: <20111201143952.9aea929b16c7212570fc1bd2@canb.auug.org.au> <20111201035113.GA7647@kroah.com> <20111201183956.GA32559@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Greg KH wrote:

> > > Today's linux-next merge of the staging tree got a conflict in
> > > drivers/hid/hid-hyperv.c between commit b95f5bcb811e ("HID: Move the
> > > hid-hyperv driver out of staging") from the hid tree and various commits
> > > from the staging tree (this was drivers/staging/hv/hv_mouse.c).
> > > 
> > > The commit message says that all the changes that happened when this file
> > > moved from staging have also been applied to the staging file, so I just
> > > used the version from the hid tree.
> > 
> > Ok, that's fine, Jiri, want me to just delete the driver from my tree
> > now to remove any of these conflicts?
> 
> I've removed it from my tree now.

Yes, I think it's the proper thing to do now.

Thanks,

-- 
Jiri Kosina
