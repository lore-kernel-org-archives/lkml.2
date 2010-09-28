Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577Ab0I1CiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:38:01 -0400
Received: from haybaler.sackheads.org ([140.186.190.103]:62506 "EHLO
	haybaler.sackheads.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab0I1CiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:38:00 -0400
X-Greylist: delayed 1928 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 22:38:00 EDT
DomainKey-Signature: a=rsa-sha1; s=haybaler; d=sackheads.org; c=nofws; q=dns;
	h=dkim-signature:received:received:date:from:to:subject:
	message-id:mime-version:content-type:content-disposition:user-agent;
	b=E8UaY2/09AtCn9G6aG62s0Z7eDpu6+hPm6fic76mGupxcC/H8hP+Kh2pV4M2dnhFR
	x6n8f8oq5oLr8lTfGCWKjMk8/MirXm1y3Xe4QlM9rK92XUhnBw9VlOcf3hiphxRywDW
	vENBGHYiegPrc7T3MyYRqai7JO+ye7o3m3IcXso=
Date: Mon, 27 Sep 2010 22:05:48 -0400
From: Jimmie Mayfield <mayfield@sackheads.org>
To: linux-kernel@vger.kernel.org
Subject: Trying to reset a PCIe device and scratching my head...
Message-ID: <20100928020548.GA90230@sackheads.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.  I'm in the process of writing a device driver for a PCIe
device where the bulk of the logic, including the PCIe interface, is 
implemented on a couple of large FPGAs.  Current target platform is x86 
Linux.

Having the PCIe interface implemented inside FPGA 'A' makes upgrading
that particular FPGA rather troublesome.  In a perfect world, one would
be able to upgrade the FPGA without having to reboot the machine.  The
hardware guys have designed the card to reload that FPGA image upon a
slot reset...either fundamental or hot.  (If I could guarantee the
card would always be plugged into a hotplug-capable slot, I suppose I could
forge a hotplug event and toggle power to the slot.  But I can't impose
that requirement on customers.)

So I'd like to be able to send either a fundamental or hot reset to the
device but so far I've had no success.  Is there a recommended way of doing 
this on x86 Linux?  

Jimmie

