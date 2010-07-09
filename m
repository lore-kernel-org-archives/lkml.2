Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0GIKYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:24:44 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:28237 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab0GIKYm (ORCPT
	<rfc822;groupwise-jlee@novell.com:7:1>);
	Fri, 9 Jul 2010 06:24:42 -0400
Message-Id: <4C378586020000230001CAF9@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 09 Jul 2010 04:24:38 -0600
From: "Joey Lee" <jlee@novell.com>
To: <greg@kroah.com>
Cc: <mzxreary@0pointer.de>, <axel.lin@gmail.com>, <rpurdie@linux.intel.com>,
       <mjg@redhat.com>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] msi-laptop: make struct rfkill_ops const
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 

於 四，2010-07-08 於 11:39 -0700，Greg KH 提到：
> On Thu, Jul 08, 2010 at 11:53:15AM -0600, Joey Lee wrote:
> > Hi Axel, 
> > 
> > 於 四，2010-07-08 於 10:08 +0800，Axel Lin 提到：
> > > rfkill uses a const struct rfkill_ops pointer.
> > > 
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > > ---
> > >  drivers/platform/x86/msi-laptop.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> > > index afd762b..05634f8 100644
> > > --- a/drivers/platform/x86/msi-laptop.c
> > > +++ b/drivers/platform/x86/msi-laptop.c
> > > @@ -562,15 +562,15 @@ static int rfkill_threeg_set(void *data, bool blocked)
> > >  	return 0;
> > >  }
> > >  
> > > -static struct rfkill_ops rfkill_bluetooth_ops = {
> > > +static const struct rfkill_ops rfkill_bluetooth_ops = {
> > >  	.set_block = rfkill_bluetooth_set
> > >  };
> > >  
> > > -static struct rfkill_ops rfkill_wlan_ops = {
> > > +static const struct rfkill_ops rfkill_wlan_ops = {
> > >  	.set_block = rfkill_wlan_set
> > >  };
> > >  
> > > -static struct rfkill_ops rfkill_threeg_ops = {
> > > +static const struct rfkill_ops rfkill_threeg_ops = {
> > >  	.set_block = rfkill_threeg_set
> > >  };
> > >  
> > 
> > The patch good to me, do I need Signed-off it?
> > How can I signed off a patch?
> 
> You can say:
> 	Signed-off-by: your name <your_email>
> 
> and then Matthew will add it.
> 
> Or you can take the original patch, add your signed-off-by, and resend
> it to Matthew keeping the correct authorship information there by making
> sure the first line in the body of the email has:
> 	From: Original author <email>
> 
> so git will get it right.
> 
> hope this helps,

Thank's for your kindly teach, it's useful to a rookie. :-)

Joey Lee

