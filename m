Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2CZMte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 08:49:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2CZMtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 08:49:33 -0400
Date: Mon, 26 Mar 2012 08:49:29 -0400
From: Dave Jones <davej@redhat.com>
To: Guan Xin <guanx.bac@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Remove over-broad module alias from zaurus.
Message-ID: <20120326124929.GA4190@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Guan Xin <guanx.bac@gmail.com>, linux-kernel@vger.kernel.org
References: <CANeMGR5xS6GwG18q5QnKt5_pWJB4fEKFoywZDx=kA_JFVREGxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeMGR5xS6GwG18q5QnKt5_pWJB4fEKFoywZDx=kA_JFVREGxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:39:48AM +0200, Guan Xin wrote:
 > > On Fri, 17 Jun 2011 20:02:10 -0400, Dave Jones wrote:
 > > This module and a bunch of dependancies are getting loaded on several
 > > of laptops I have (probably picking up the mobile broadband device),
 > > that have nothing to do with zaurus. Matching by class without
 > > any vendor/device pair isn't the right thing to do here, as it
 > > will prevent any other driver from correctly binding to it.
 > > (Or in the absense of a driver, will just waste time & memory by
 > >  unnecessarily loading modules)
 > >
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > > -	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MDLM,
 > > -			USB_CDC_PROTO_NONE),
 > > -	.driver_info = (unsigned long) &bogus_mdlm_info,
 > > -}, {
 > >  	/* Motorola MOTOMAGX phones */
 > >  	USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
 > >  			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
 > 
 > After removal of this, my Motorola Rokr E6 (22b8:6027) cannot be recognized.
 > Can this be added back with more specific device info, just like the
 > Motorola MOTOMAGX phones?

Yes, just cut-n-paste one of the other entries, change the ID,
make sure it works and send a diff.

	Dave
