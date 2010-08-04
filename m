Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab0HDUJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:09:31 -0400
Received: from www84.your-server.de ([213.133.104.84]:34718 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934590Ab0HDUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:09:21 -0400
Subject: Re: new gerneric kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        tytso@mit.edu
In-Reply-To: <20100804194617.GA30773@suse.de>
References: <201005132135.o4DLZ9WI021613@imap1.linux-foundation.org>
	 <1280905854.8441.3.camel@wall-e.seibold.net>
	 <20100804194617.GA30773@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 Aug 2010 22:09:11 +0200
Message-ID: <1280952551.8594.0.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 04.08.2010, 12:46 -0700 schrieb Greg KH:
> On Wed, Aug 04, 2010 at 09:10:54AM +0200, Stefani Seibold wrote:
> > Hi,
> > 
> > once again. Kernel 2.6.35 is out and i want to know if there is play plan to
> > merge the generic kfifo API. All complains was fixed, so there is no
> > reason to shift the merge again. Please gibe me a short answer.
> 
> These have been in the -mm tree for a few major kernel releases now,
> right?  And they are API safe, and only change the internals, right?
> 
> If so, I see no objection to merging them now, especially as you will be
> around to fix up any problems that people have, right?  :)
> 

right!



