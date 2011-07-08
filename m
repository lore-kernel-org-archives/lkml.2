Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1GHI3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:29:38 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:44606 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1GHI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:29:35 -0400
Date: Fri, 8 Jul 2011 10:29:11 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110708102911.3c4d83b6@mschwide>
In-Reply-To: <201107072336.26151.rjw@sisk.pl>
References: <20110608074523.211912903@de.ibm.com>
	<201106142250.15041.rjw@sisk.pl>
	<20110615093629.07f01779@mschwide>
	<201107072336.26151.rjw@sisk.pl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 23:36:25 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, June 15, 2011, Martin Schwidefsky wrote:
> > On Tue, 14 Jun 2011 22:50:14 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> ...
> > 
> > Well before the preallocation kicked in we don't know which are the relevant
> > storage keys. The only other option would be to store all of them which I
> > consider to be a inferior solution. 
> 
> I've been thinking about that recently a bit.
> 
> Don't we need to restore the keys of the page frames that aren't copied
> into the image too?

Pages that are free (= not part of the image) will get a zero storage key
once they are allocated again. So no, we do not need to include these
keys into the hibernation image.


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

