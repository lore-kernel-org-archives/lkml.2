Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab0DAQ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:56:23 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51506 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755043Ab0DAQ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:56:16 -0400
Date: Thu, 1 Apr 2010 18:56:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
Message-ID: <20100401165606.GA1677@ucw.cz>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com> <201003310125.26266.laurent.pinchart@ideasonboard.com> <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Do you mean the dmesg output ?
> A full dmesg is included in this address :
> http://pastebin.com/8XU619Uk
> Not in all suspend/hibernate the problem comes, only in some of them
> and this included dmesg output is just after a non working case of
> webcam fault.
> 
> 
> I also have found this in `/var/log/messages | grep uvcvideo`
> Mar 31 00:31:16 linux-l365 kernel: [399905.714743] usbcore:
> deregistering interface driver uvcvideo
> Mar 31 00:31:24 linux-l365 kernel: [399914.121386] uvcvideo: Found UVC
> 1.00 device LG Webcam (0c45:62c0)
> Mar 31 00:31:24 linux-l365 kernel: [399914.135661] usbcore: registered
> new interface driver uvcvideo

Also try unloading uvcvideo before suspend and reloading it after
resume...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
