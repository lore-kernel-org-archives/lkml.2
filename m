Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0IYWXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:23:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0IYWXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:23:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 05/22] Hibernation: Switch to preallocating swap.
Date: Sun, 26 Sep 2010 00:22:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> <201009252324.39445.rjw@sisk.pl> <4C9E6A75.8090702@tuxonice.net>
In-Reply-To: <4C9E6A75.8090702@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009260022.36244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 25, 2010, Nigel Cunningham wrote:
> Morning.
> 
> On 26/09/10 07:24, Rafael J. Wysocki wrote:
> > On Saturday, September 25, 2010, Nigel Cunningham wrote:
> >> Switch from allocating swap as the image is written to allocating
> >> storage prior to writing the image.
> >
> > Hmm, I think I know what the patch does, but I don't really understand the
> > changelog.  Care to explain/fix?
> 
> Sure. I was a little terse, wasn't I? :)
> 
> Prior to this patch, we allocated swap as we were writing the image. 
> This patch changes things so that we instead allocate all the swap we'll 
> need prior to starting to write the image. It lays groundwork for later 
> patches that switch from doing I/O in batches.

Good.  I'll use the above as a replacement changelog if you don't mind.

Thanks,
Rafael
