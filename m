Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1BSQGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 11:06:38 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59441 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab1BSQGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 11:06:37 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sat, 19 Feb 2011 21:36:22 +0530
Subject: RE: [PATCH 1/2] PRUSS UIO driver support
Thread-Topic: [PATCH 1/2] PRUSS UIO driver support
Thread-Index: AcvPjfEd7sStzYzrTemSHU8cGE8i8gAvaVQQ
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024B83C10E@dbde02.ent.ti.com>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <1298041530-26855-2-git-send-email-pratheesh@ti.com>
 <20110218163147.GD4684@local> <20110218170538.GB11773@suse.de>
In-Reply-To: <20110218170538.GB11773@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, February 18, 2011 10:36 PM
> To: TK, Pratheesh Gangadhar
> Cc: Hans J. Koch; davinci-linux-open-source@linux.davincidsp.com;
> Chatterjee, Amit; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 1/2] PRUSS UIO driver support
> 
> On Fri, Feb 18, 2011 at 05:31:47PM +0100, Hans J. Koch wrote:
> > On Fri, Feb 18, 2011 at 08:35:29PM +0530, Pratheesh Gangadhar wrote:
> > > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> 
> As noted by others, this needs to go at the end of the changelog
> comment.
> 
> Also, always run your patches through the scripts/checkpatch.pl script
> and fix the warnings and errors it finds.  To not do so is just rude as
> you are asking us to do the basic review work that you yourself did not
> do in the first place.

I actually ran checkpatch multiple times, but made some more changes before sending and missed to run again. Sorry about this. Will make sure these issues are fixed in the next version.
> 
> > > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > > +{
> > > +	return IRQ_HANDLED;
> > > +}
> >
> > ROTFL. That reminds me of an old story. The last time I wrote this, and
> > Greg dared to post it, we received this reply:
> >
> > http://marc.info/?l=linux-kernel&m=116604101232144&w=2
> >
> > So, if you really have a _very_ good reason why this _always_ works on
> > _any_ DA850 board, add a comment that explains why. Otherwise the whole
> > patch set will be doomed.
> 
> Nope, this whole patch set is doomed if this isn't fixed, I'm not going
> to accept it no matter how much you want to try to say this is ok on
> this hardware.
Okay. I had some queries in the previous mail. Will fix this once I am clear about the options.

Thanks,
Pratheesh
