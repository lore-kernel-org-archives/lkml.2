Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1GZQoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:44:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37350 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431Ab1GZQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:44:11 -0400
X-Sasl-enc: CWV7qLd2pVoKA6eSqUxaUFkaCZv/zhLEg5d2wBDp7mn2 1311698650
Date: Tue, 26 Jul 2011 09:39:23 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [GIT PATCH] STAGING patches for 3.1
Message-ID: <20110726163923.GA7716@kroah.com>
References: <20110726051533.GA2835@kroah.com>
 <CA+55aFwOgkOXmY654-qbuiFFnUC1yXZ27DBDFR02JP12NxAF9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwOgkOXmY654-qbuiFFnUC1yXZ27DBDFR02JP12NxAF9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:31:48PM -0700, Linus Torvalds wrote:
> On Mon, Jul 25, 2011 at 10:15 PM, Greg KH <greg@kroah.com> wrote:
> >
> > Note, I have not successfully merged this with your tree yet, the
> > diffstat below is against the 3.0-rc6 tree.  When merging with your
> > tree, there are a number of merge issues that I trust you can resolve
> > easier than I can.  If you have problems, please let me know and I will
> > fix them up on Wednesday when I get done driving to my next hotel
> > location.
> 
> No problem, some of the merge conflicts looked a bit ugly, but they
> were all trivial. Most of them was due to some trivial removed or
> added #include lines, and it just then clashed with your much bigger
> changes. Easy enough to sort out, and in couple of cases the bigger
> changes had just made the small changes irrelevant too.
> 
> So all merged and pushed out. Of course, maybe I made a mistake
> somewhere, but none of it looked at all questionable (famous last
> words ;)

Great, thanks for doing this, much appreciated.

greg k-h
