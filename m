Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1K1SHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:07:52 -0500
Received: from dion.org.ua ([193.104.35.143]:49151 "EHLO dion.org.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1K1SHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:07:51 -0500
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 13:07:50 EST
Date: Mon, 28 Nov 2011 19:37:09 +0200
From: Dmitry Nezhevenko <dion@inhex.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.1.3
Message-ID: <20111128173708.GA3785@laptop.local>
References: <20111127190735.GA11899@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111127190735.GA11899@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 04:07:35AM +0900, Greg KH wrote:
> I'm announcing the release of the 3.1.3 kernel.
> 
> All users of the 3.1 kernel series must upgrade.
> 

I don't know where to report this, since bugzilla is still down. This
upgrade breaks UVC webcam that I've:

Bus 002 Device 002: ID 04f2:b029 Chicony Electronics Co., Ltd 1.3M UVC
Webcam

I'm getting followed while trying to capture from it:

	[  187.555352] uvcvideo: Failed to submit URB 0 (-28).

Kernel 3.1.2 is definitely working.

[    1.810009] usb 2-5: Product: USB2.0 1.3M UVC WebCam
[   10.664671] uvcvideo: Found UVC 1.00 device USB2.0 1.3M UVC WebCam (04f2:b029)
[   10.670255] input: USB2.0 1.3M UVC WebCam as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input7

-- 
WBR, Dmitry
