Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0ENAhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:37:08 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:17643 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab0ENAhG (ORCPT
	<rfc822;groupwise-jlee@novell.com:7:1>);
	Thu, 13 May 2010 20:37:06 -0400
Message-Id: <4BED27CE020000230001917C@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 13 May 2010 18:37:02 -0600
From: "Joey Lee" <jlee@novell.com>
To: <gregkh@suse.de>
Cc: <mzxreary@0pointer.de>, <dmitry.torokhov@gmail.com>, <greg@kroah.com>,
       <rpurdie@linux.intel.com>, <mjg@redhat.com>,
       <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state
	 with BIOS when function key pressed
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, 

於 四，2010-05-13 於 15:54 -0700，Greg KH 提到：
> On Thu, May 13, 2010 at 05:53:04AM -0600, Joey Lee wrote:
> > Hi Dmitry, 
> > 
> > Thank's for your review.
> > 
> > 於 四，2010-05-13 於 00:52 -0700，Dmitry Torokhov 提到：
> > > On Wed, May 12, 2010 at 11:56:47AM -0700, Greg KH wrote:
> > > >  static int __init msi_init(void)
> > > > @@ -819,6 +875,7 @@ static void __exit msi_cleanup(void)
> > > >  	platform_driver_unregister(&msipf_driver);
> > > >  	backlight_device_unregister(msibl_device);
> > > >  
> > > > +	i8042_remove_filter(msi_laptop_i8042_filter);
> > > 
> > > You also need cancel_delayed_work_sync() here. Sorry for not noticing
> > > this before.
> > > 
> > 
> > Yes, you are right, need add cancel_delayed_work_sync().
> 
> Want to make up an additional patch to add on top of this that does it?
> 

OK! I am doing it, and will submit another patch to fix this issue.


Thank's
Joey Lee

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

