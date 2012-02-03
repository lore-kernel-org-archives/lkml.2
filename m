Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2BCUbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:31:04 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60592 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757294Ab2BCUbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:31:01 -0500
X-Sasl-enc: eltqEG0cm44lSSrcEkN1CVNbg40iInGYhKU7aBvt7MQU 1328301060
Date: Fri, 3 Feb 2012 12:30:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Re: Linux 2.6.32.56
Message-ID: <20120203203017.GA21231@kroah.com>
References: <20120203174843.GA18600@kroah.com>
 <20120203202936.GA16466@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120203202936.GA16466@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:29:36PM -0800, Greg KH wrote:
> On Fri, Feb 03, 2012 at 09:48:43AM -0800, Greg KH wrote:
> > I'm announcing the release of the 2.6.32.56 kernel.
> 
> I forgot to include the shortlog for this release, so here it is.

Doh, wrong shortlog, I need more coffee this morning...

Alan Cox (1):
      USB: ftdi_sio: Add more identifiers

Alexey Dobriyan (2):
      crypto: sha512 - make it work, undo percpu message schedule
      crypto: sha512 - reduce stack usage to safe number

Bjørn Mork (1):
      USB: cdc-wdm: updating desc->length must be protected by spin_lock

Eric W. Biederman (1):
      usb: io_ti: Make edge_remove_sysfs_attrs the port_remove method.

Greg Kroah-Hartman (1):
      Linux 2.6.32.56

Harrison Metzger (1):
      USB: usbsevseg: fix max length

Herton Ronaldo Krzesinski (1):
      Revert "ARM: 7220/1: mmc: mmci: Fixup error handling for dma"

Jean Delvare (1):
      hwmon: (f71805f) Fix clamping of temperature limits

Johan Hovold (3):
      USB: ftdi_sio: fix TIOCSSERIAL baud_base handling
      USB: cp210x: do not map baud rates to B0
      USB: ftdi_sio: fix initial baud rate

Paolo Bonzini (2):
      block: fail SCSI passthrough ioctls on partition devices
      dm: do not forward ioctls from logical volumes to the underlying device

Peter Korsgaard (1):
      USB: ftdi_sio: add PID for TI XDS100v2 / BeagleBone A3

Peter Naulls (1):
      USB: serial: ftdi additional IDs

Renato Caldas (1):
      USB: serial: CP210x: Added USB-ID for the Link Instruments MSO-19

Thomas Hellstrom (1):
      drm: Fix authentication kernel crash

Tim Gardner (1):
      ecryptfs: Improve metadata read failure logging

Tyler Hicks (2):
      eCryptfs: Sanitize write counts of /dev/ecryptfs
      eCryptfs: Make truncate path killable

Vivien Didelot (1):
      hwmon: (sht15) fix bad error code

