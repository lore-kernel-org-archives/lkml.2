Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1LENXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:23:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39509 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab1LENW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:22:58 -0500
MIME-Version: 1.0
Date: Mon, 5 Dec 2011 13:22:57 +0000
Message-ID: <CAP_ERaEQZH=a1DkbWDgpPHSuk7e=unHsBmtD1=7C4G-pSFnhmg@mail.gmail.com>
Subject: PCTV452e unable to tune in Kernel 3.2 RC3 / RC4
From: Neil Sutton <sutton.nm@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying to make my TT S2-3600 work with Kernel 3.2 - Tried RC3 and
RC4 - (I believe it now supports this adapter via PCTV452e)
So, I enabled the PCTV452e module in the kernel config and the device
detects ok;

[   12.075239] dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm state.
[   12.076620] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   12.080767] dvb-usb: MAC address: 00:d0:5c:64:54:95
[   13.298383] dvb-usb: Technotrend TT Connect S2-3600 successfully
initialized and connected.

But when I try to make any tuning with the device I get no picture and
the following get put to syslog;

Dec  2 01:01:26 MicroServer kernel: [ 1535.331468] dvb-usb: could not
submit URB no. 0 - get them all back
Dec  2 01:01:26 MicroServer kernel: [ 1535.372388] pctv452e: I2C error
-121; AA 97  CC 00 01 -> 55 97  CC 00 00.
Dec  2 01:01:26 MicroServer kernel: [ 1535.385003] pctv452e: I2C error
-121; AA AE  CC 00 01 -> 55 AE  CC 00 00.
Dec  2 01:01:26 MicroServer kernel: [ 1535.444992] pctv452e: I2C error
-121; AA C9  CC 00 01 -> 55 C9  CC 00 00.

The 'URB' errors appear each time the card moves to a new transponder,
the I2C errors appear to be when the card is attempting to lock a
channel within the current transponder.

Does anyone have any thoughts on what might be causing this ? - I've
had a search around but can't really find the problem mentioned
anywhere... the device works fine under the latest liplianin drivers.

I posted this a few days back at the linuxdvb list, but I'm not
entirely sure where this falls, so apologies if this is not the
correct place to report this!

Many Thanks
Neil
