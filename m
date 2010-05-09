Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0EIOWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 10:22:22 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:59735 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0EIOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 10:22:17 -0400
Date: Sun, 9 May 2010 16:22:09 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: peter.hicks@poggs.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: RE: option.ko: ZTE MF636 support
Message-ID: <20100509142209.GA9319@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273325258.15521.38.camel@angel>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

Got an Olivetti olicard100 UMTS/HSDPA device here.

Devices: /dev/ttyUSB{0,1,2,3,4}

Similar symptoms are the long delay on opening of devices 0 and 2.
/dev/ttyUSB0: status port
/dev/ttyUSB2: modem port (not working)

Devices 1,3,4 are not usable in any way so far.

More info about this at:

http://www.draisberghof.de/usb_modeswitch/bb/viewtopic.php?t=391

What has been your solution to get the ZTE working?

With the olicard100 there's so far been only one successful connection,
since then: nothing. pppd hangs spitting out non-printable chars, but
there's no answer from uplink, lcp config reqs are timing out.

Cheers,

Nils

