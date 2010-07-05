Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0GETxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:53:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62020 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0GETxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:53:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
Date: Mon, 5 Jul 2010 21:52:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <4C3235C3.7050303@zytor.com> <20100705194759.GE5240@nowhere>
In-Reply-To: <20100705194759.GE5240@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007052152.55954.arnd@arndb.de>
X-Provags-ID: V02:K0:8gn5J7KX3EhYJdtTiqnUes9QNHFyOQn+orDi9zCKGrr
 cYBySjj8Sg/AllOeoIoYFISVsIYey/j1bwhTaHBB4TjRH6b3NO
 gQduS305Y2yBqHjEoFZbPkz3nexvexbzDar3Yg+OchjiTkRooc
 mA7mDoLWonOSVZ3pyUrIfZ6xHOLcJpdnLB1vomCZUhQ9VuHbN+
 itTM7aLVvw/1eu/+l1udw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 July 2010 21:48:01 Frederic Weisbecker wrote:
> On Mon, Jul 05, 2010 at 12:42:59PM -0700, H. Peter Anvin wrote:
> > On 07/05/2010 12:24 PM, Frederic Weisbecker wrote:
> > > 
> > > Peter, if you're fine with this version. May I apply it?
> > > Unless you have a tree for autofs.
> > > 
> > Ian Kent is the maintainer of autofs4 and patches for autofs4 should go
> > through him (or acked by him.)
> > 
> > autofs 3 is officially unmaintained; I'm more than happy to have you
> > push the autofs 3 bits of this patch.
> 
> Sure, I can split up the patch and integrate the autofs 3 part, I'll send
> the standalone autofs4 version to Ian.

I think in this case it's really more appropriate to change both autofs3
and autofs4 together, to avoid interdependencies. Whichever way Ian
prefers (ack the patch or take it) would work though.

	Arnd
