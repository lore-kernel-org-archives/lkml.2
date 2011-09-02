Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1IBVlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 17:41:49 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32935 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076Ab1IBVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:41:48 -0400
X-Sasl-enc: OYYaJ7rdVxux2stDYvgux3peygEh8rGZk1jNEmbpr9qO 1314999706
Date: Fri, 2 Sep 2011 14:41:19 -0700
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb-devel@lists.sourceforge.net>,
        "usb-storage@lists.one-eyed-alien.net" 
	<usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating
 autosense
Message-ID: <20110902214119.GA6747@kroah.com>
References: <CAM9Y=f6eSgxsbrO11d0ux72NJip14xGQDeX84VWb9uiBtEVsjA@mail.gmail.com>
 <20110902181826.GA29848@kroah.com>
 <CB97E92C-3990-418B-BA04-94073E011ECE@yahoo.com>
 <20110902192250.GA440@kroah.com>
 <F4F1DCC3-F173-47B8-BD90-E868850E55ED@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F4F1DCC3-F173-47B8-BD90-E868850E55ED@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 02:28:50PM -0700, Luben Tuikov wrote:
> On Sep 2, 2011, at 12:22, Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Sep 02, 2011 at 12:08:44PM -0700, Luben Tuikov wrote:
> >> On Sep 2, 2011, at 11:18, Greg KH <greg@kroah.com> wrote:
> >> 
> >>> On Fri, Sep 02, 2011 at 02:24:36PM +0800, Daniel J Blueman wrote:
> >>>> Hi Luben, Greg, Matthew,
> >>>> 
> >>>> Any plan for reviewing and accepting this patch [1] yet? I'm still
> >>>> seeing the symptoms on USB 3 SATA bridges with linux-3.0+.
> >>> 
> >>> I needed an ack from Matthew before I could take it.
> >>> 
> >>> Matthew?
> >> 
> >> 
> >> He acked it already: http://marc.info/?l=linux-kernel&m=128950140420081&w=2
> >> 
> >> But interestingly enough, it never made it into your tree. 
> > 
> > Odd, you did, and I found the resend I asked for in my archives, but I
> > don't see it in the tree, I don't know what happened here, sorry.
> > 
> > I'll go queue it up when master.kernel.org comes back up, sorry about
> > that.
> 
> Are you sure it's mine. I don't remember resending it other than the
> "take 2" thread (link above).

I have a Message-ID: <929551.13749.qm@web31805.mail.mud.yahoo.com>
in my inbox that looks like it was the message needed, did I just edit
that one by hand with the needed acks?

I'll bounce it to you for verification.

greg k-h
