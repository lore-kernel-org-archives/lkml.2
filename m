Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0DMV33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:29:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49680
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab0DMV30 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:29:26 -0400
Date: Tue, 13 Apr 2010 14:29:30 -0700 (PDT)
Message-Id: <20100413.142930.34014646.davem@davemloft.net>
To: agimenez@sysvalve.es
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
       gregkh@suse.de, jonas.sjoquist@ericsson.com, steve.glendinning@smsc.com,
       torgny.johansson@gmail.com, dbrownell@users.sourceforge.net,
       omar.oberthur@gmail.com, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH Resubmission] drivers/net/usb: Add new driver ipheth
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC4BFFD.9040802@sysvalve.es>
References: <1270678281-20750-1-git-send-email-agimenez@sysvalve.es>
	<20100413.011540.115903049.davem@davemloft.net>
	<4BC4BFFD.9040802@sysvalve.es>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "L. Alberto Giménez" <agimenez@sysvalve.es>
Date: Tue, 13 Apr 2010 21:03:25 +0200

> Thanks for the info. I didn't know that I had to add an entry on the
> upper level Makefile. I guess that something like
> obj-$(CONFIG_USB_IPHETH) += usb/ should be enough? (I got it from the
> other USB net drivers).

Yes.
