Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2K3IZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:25:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27367 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2K3IZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:25:40 -0500
Date: Fri, 30 Nov 2012 11:25:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in
 serqt_usb2.c
Message-ID: <20121130082527.GU11248@mwanda>
References: <1354165076-30273-1-git-send-email-yamanetoshi@gmail.com>
 <20121130021026.GB2056@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130021026.GB2056@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 06:10:26PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 29, 2012 at 01:57:56PM +0900, YAMANE Toshiaki wrote:
> >  
> > -				ProcessLineStatus(qt_port, data[i + 3]);
> > -
> >  				i += 3;
> > +				ProcessLineStatus(qt_port, data[i]);
> 
> I think you just changed the logic in this function, didn't you?

This should be ok.  The i += 3 was there in the original, it's just
moved up a line.

regards,
dan carpenter

