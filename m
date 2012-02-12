Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2BLQre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 11:47:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45103 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473Ab2BLQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 11:47:33 -0500
X-Sasl-enc: lJKLKSLeyVLiBwAkDa+uOrrt4Yr7srIq8IUxaxgRCS2M 1329065251
Date: Sun, 12 Feb 2012 08:47:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: ALPS touchpad no longer recognizing 'taps' as mouseclick in 3.3-rc3
Message-ID: <20120212164728.GA19629@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This problem has been since 3.3-rc1, but I only now am getting around to
reporting it, sorry about that.

In 3.3-rc3, my alps touchpad isn't recognizing a tap on the touchpad as
a mouse click.  Is there a new Kconfig option that I need to enable?

My /proc/bus/input/devices entry for this thing is:
I: Bus=0011 Vendor=0002 Product=0008 Version=7326
N: Name="AlpsPS/2 ALPS DualPoint TouchPad"
P: Phys=isa0060/serio1/input0
S: Sysfs=/devices/platform/i8042/serio1/input/input6
U: Uniq=
H: Handlers=mouse1 event6 
B: PROP=8
B: EV=b
B: KEY=e420 70000 0 0 0 0
B: ABS=260800001000003

Is there anything else you need me to report to help track this down?

thanks,

greg k-h
