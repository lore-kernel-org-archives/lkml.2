Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2F1NQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 09:16:54 -0400
Received: from gherkin.frus.com ([192.158.254.49]:58731 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab2F1NQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:16:53 -0400
Date: Thu, 28 Jun 2012 08:16:51 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: 3.5-rcX: USB support without udev?
Message-ID: <20120628131651.GA14492@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the removal of the deprecated usbfs feature in the 3.5 release
candidates, is there a way of getting USB devices working on a non-
embedded Linux system without udev (static "/dev")?

Assume I have a way to determine the appropriate device nodes to create
under /dev/bus/usb.  What else is needed to get USB keyboards and mice
working again?  The mapping of a particular USB device to a class
(input, generic_usb, etc.) that used to happen before USB_DEVICE_CLASS
was removed is the part I'm missing.

Thanks in advance.

--Bob
