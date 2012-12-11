Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2LKUYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:24:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45718 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176Ab2LKUYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:24:06 -0500
Message-ID: <1355257444.24219.7.camel@joe-AO722>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jason Baron <jbaron@redhat.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Dec 2012 12:24:04 -0800
In-Reply-To: <20121211201250.GA19675@kroah.com>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1353263740.28214.2.camel@joe-AO722> <20121120160845.GB31176@redhat.com>
	 <3645415.mrRzvuvPFK@lx-vladimir> <20121211193646.GS15974@pogo>
	 <20121211200831.GD11815@redhat.com> <20121211201250.GA19675@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 12:12 -0800, Greg KH wrote:
> On Tue, Dec 11, 2012 at 03:08:31PM -0500, Jason Baron wrote:
> > On Tue, Dec 11, 2012 at 11:36:46AM -0800, Luis R. Rodriguez wrote:
> > > On Tue, Dec 04, 2012 at 11:28:26AM +0200, Vladimir Kondratiev wrote:
> > > > Hi Jason,
> > > > 
> > > > Do you have any update on the status for patches below?
> > > > Where is it now? When do you expect it to merge? 3.8?
> > > > I am waiting for this to merge before I can go on
> > > > with my driver.
> > > 
> > > *poke*
> > > 
> > >   Luis
> > 
> > Hi Luis,
> > 
> > Yes, I posted this patch, along with 2 others last week for Greg to
> > pull. I believe these are too late for the 3.8 merge window. Perhaps,
> > Greg can comment. Here's a link to the post:
> > 
> > http://marc.info/?l=linux-kernel&m=135474417810281&w=2
> 
> Yes it's too late, these will go into linux-next after 3.8-rc1 is out.
> 
> thanks,
> 
> greg k-h
> 

Vladimir, sorry about this.

I suggest you prefix/rename and include these functions directly into
your driver and later after 3.9 is out you could again rename the
local calls to the now generic kernel functions and delete the local
ones.

Your driver is for new hardware, so even now it should be able to
go into 3.8.

cheers, Joe

