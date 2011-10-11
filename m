Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1JKQLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:11:19 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41834 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab1JKQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:11:18 -0400
X-Sasl-enc: vTFPm1pO56oBCrqnaoCN+qpBdoTqJiPigQPfrjI7V38Y 1318349476
Date: Tue, 11 Oct 2011 10:07:16 -0600
From: Greg KH <greg@kroah.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: et131x: Update TODO list
Message-ID: <20111011160715.GA29114@kroah.com>
References: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
 <20111011145332.GA29114@elliptictech.com>
 <CANK3SE08pTAPyEKHAGhqacpBcEk8eq8R6o9=z3kK-Qx0+hwm-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANK3SE08pTAPyEKHAGhqacpBcEk8eq8R6o9=z3kK-Qx0+hwm-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 04:47:57PM +0100, Mark Einon wrote:
> On 11 October 2011 15:53, Nick Bowler <nbowler@elliptictech.com> wrote:
> > Hi Mark,
> >
> > On 2011-10-10 16:22 +0100, Mark Einon wrote:
> >> diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
> >> index d383e80..c67f83e 100644
> >> --- a/drivers/staging/et131x/README
> >> +++ b/drivers/staging/et131x/README
> >> @@ -2,13 +2,18 @@ This is a driver for the ET1310 network device.
> >>
> >>  Based on the driver found at https://sourceforge.net/projects/et131x/
> >>
> >> -Cleaned up immensely by Olaf Hartman and Christoph
> >> -Hellwig <hch@infradead.org>
> >> +Cleaned up immensely by Olaf Hartman and Christoph Hellwig <hch@infradead.org>
> >
> > It seems that a fragment from your earlier patch, "staging: et131x:
> > Removing Olaf Hartmann's email as it bounces", got mixed up with this
> > one.
> 
> Hi Nick,
> 
> Well spotted!
> 
> Actually, I was just sneaking in the removal of a carriage return
> which I didn't do in the earlier patch.
> 
> I didn't think that anyone would mind, being in an unnoticeable README
> file in the staging directory of a staging-next tree - inhabiting a
> small, insignificant blue green planet, circling a star we call the
> Sun, in an unfashionable outer spiral arm of a galaxy known as the
> Milky Way.
> 
> Let me know if its a problem.

It's really not for something like this, I'll take it as-is.

greg k-h
