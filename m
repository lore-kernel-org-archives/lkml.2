Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2G1L0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:26:40 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:55464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2G1L0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:26:39 -0400
Message-ID: <1343474795.4980.4.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH] Documentation: fix DOCBOOKS=... building
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sat, 28 Jul 2012 13:26:35 +0200
In-Reply-To: <5013162C.9030606@xenotime.net>
References: <1339577020.4519.19.camel@jlt3.sipsolutions.net>
	 <5013162C.9030606@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 15:29 -0700, Randy Dunlap wrote:
> On 06/13/2012 01:43 AM, Johannes Berg wrote:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Prior to 
> > commit 4266129964b8238526936d723de65b419d8069c6
> > Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date:   Tue May 31 16:27:44 2011 -0300
> > 
> >     [media] DocBook: Move all media docbook stuff into its own directory
> > 
> > it was possible to build only a single (or more)
> > book(s) by calling, for example
> > 	make htmldocs DOCBOOKS=80211.xml
> > 
> > This now fails:
> > cp: target `.../Documentation/DocBook//media_api' is not a directory
> > 
> > Ignore errors from that copy to make this possible again.
> > 
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > I complained about this a long time ago, but now it finally bothered me
> > enough to fix it ... :-)
> 
> 
> Thanks.
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Can you apply it somewhere, or should I send it to Andrew, or do you
have any other ideas?

johannes

