Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2DPSeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:34:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab2DPSeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:34:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Mon, 16 Apr 2012 20:38:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204160008.41104.rjw@sisk.pl> <1334529077.2092.1.camel@shrek.rexursive.com>
In-Reply-To: <1334529077.2092.1.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204162038.38760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Bojan Smojver wrote:
> On Mon, 2012-04-16 at 00:08 +0200, Rafael J. Wysocki wrote:
> > > Signed-off-by: Per Olofsson <pelle@debian.org>
> > 
> > Why signed-off? 
> 
> Per contributed significantly to the development of the patch. In fact,
> it was Per who noticed what the problem with number of free pages
> calculation during hibernation actually was.

OK, but you wrote the patch in the end.

Reviewed-by from Per would be more appropriate.

Signed-off-by means as much as "I certify that am the author of this patch" or
"This patch has gone through my hands and I know who the author is" (it implies
"Acked-by" in the latter case).  None of these is the case here.

Thanks,
Rafael
