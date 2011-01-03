Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1ACOJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:09:38 -0500
Received: from hermes.garlic.com ([216.139.0.86]:59396 "EHLO hermes.garlic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab1ACOJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:09:37 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 09:09:37 EST
Subject: Offset into block file for mounting?
From: Tom Watson <tsw@johana.com>
Reply-To: tsw@johana.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: I'm at home now
Date: Mon, 03 Jan 2011 05:13:04 -0800
Message-Id: <1294060384.3030.18.camel@xytar7a>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I recently got a "floppy drive emulator" that uses an USB thumb drive to
emulate floppy images to be used as a floppy drive.  In trying out the
software (it is a bit cryptic), I found that this model stores the
floppy images consecutively on said thumb drive (with some padding to
make the drives on 1.5 Mbyte borders on the thumb drive.  When plugging
in the thumb drive, the 'vfat' module just mounts the first image (as I
expect).  What I would like to do is mount some of the other images that
exist (I dumped out the raw thumb drive).  I believe that a simple way
to do this is to add an offset to the vfat mount, so that the accesses
begin at (as in my example) 0x180000 (and multiples thereof) from the
start of the physical drive.

Is there any way to add such an offset?
Would it be useful in any other file systems?

Sorry, but there is no partition map in the way this device formats the
thumb drive.  I suspect that this is due to the way it was designed, and
it makes the task much simpler to do it that way (and I have no way of
changing the hardware simply).

My reason for doing this is that I want to use this device in my Data
I/O programmer, which has ONLY a floppy interface, and I am a bit tired
of playing the shuffle game for the programmers disks.  I also want to
transfer data as well, and having the ability to do the offset  where
one finds the disk image makes this useful.

Thanks for any assistance.  Please copy me on replies, as I don't
currently subscribe.

p.s.  A similar item is on ebay:
http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=290507795223 (I tried
to make the URL as short as possible!)
-- 
Tom Watson <tsw@johana.com>
I'm at home now

