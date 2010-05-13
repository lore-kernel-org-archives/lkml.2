Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab0EMLxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:53:12 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:23311 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758796Ab0EMLxJ (ORCPT
	<rfc822;groupwise-jlee@novell.com:7:1>);
	Thu, 13 May 2010 07:53:09 -0400
Message-Id: <4BEC74C002000023000190EE@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 13 May 2010 05:53:04 -0600
From: "Joey Lee" <jlee@novell.com>
To: <dmitry.torokhov@gmail.com>
Cc: <mzxreary@0pointer.de>, <greg@kroah.com>, <rpurdie@linux.intel.com>,
       <mjg@redhat.com>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state
	 with BIOS when function key pressed
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, 

Thank's for your review.

於 四，2010-05-13 於 00:52 -0700，Dmitry Torokhov 提到：
> On Wed, May 12, 2010 at 11:56:47AM -0700, Greg KH wrote:
> >  static int __init msi_init(void)
> > @@ -819,6 +875,7 @@ static void __exit msi_cleanup(void)
> >  	platform_driver_unregister(&msipf_driver);
> >  	backlight_device_unregister(msibl_device);
> >  
> > +	i8042_remove_filter(msi_laptop_i8042_filter);
> 
> You also need cancel_delayed_work_sync() here. Sorry for not noticing
> this before.
> 

Yes, you are right, need add cancel_delayed_work_sync().

Joey Lee

