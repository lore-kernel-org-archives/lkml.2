Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0DVDXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 23:23:43 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:39644 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0DVDXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 23:23:42 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: core: workque: workqueue recursion when unplugging usb WCDMA modem on 2.6.32 kernel
Date: Wed, 21 Apr 2010 20:15:52 -0700
Message-ID: <ED2979D1CA1B3E4BB166ED9990088522765E30@SJOAMSEXB01.AMERICAS.ROOT.PRI>
In-Reply-To: <20100421182747.GB7876@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: core: workque: workqueue recursion when unplugging usb WCDMA modem on 2.6.32 kernel
Thread-Index: AcrhgJX3WtfqbC0eS/apoxqcDt4rFgAR1KTA
References: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI> <20100421182747.GB7876@kroah.com>
From: "YuPing Luo" <YuPing.Luo@csr.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2010 03:22:44.0522 (UTC) FILETIME=[12E700A0:01CAE1CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, Apr 20, 2010 at 11:27:55PM -0700, YuPing Luo wrote:
> Is your console on a usb to serial device?  Or a serial port?
> if usb to serial, can you try .33-rc5 and let us know if that solves
the problem?
> greg k-h

 The console is over serial port, while the usb modem exported 2 serial
ports .
 The recursion can be avoided if introducing one dedicated work queue
thread for binder (
http://android.git.kernel.org/?p=kernel/common.git;a=blob;f=drivers/stag
ing/android/binder.c;h=99010d4b3044b2c33c9d709e334b5be7871b9599;hb=andro
id-2.6.32).

Thanks
Yuping


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
