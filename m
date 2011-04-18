Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1DRNWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:22:47 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55639 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751703Ab1DRNWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:22:44 -0400
Date: Mon, 18 Apr 2011 15:21:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gottfried Haider <gottfried.haider@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [Regression] Bluetooth pairing does not work anymore in
 2.6.39-rc3 (works in 2.6.38.3)
Message-ID: <20110418132140.GA1479@ucw.cz>
References: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I am having problems pairing bluetooth devices in 2.6.39. Scanning
> works fine (hcitool scan), but when I try to pair a device using
> "bluez-simple-agent hci0 $MAC", I receive the following error message:
> "Creating device failed: org.bluez.Error.Failed: Input/output error"
> 
> The same command reliably works on a 2.6.38.3 kernel with pretty much
> the same config.
> 
> According to lsusb, I have a Broadcom Bluetooth Controller with ID
> 0a5c:217f. I don't see anything related in either of the dmesgs.
> My lspci output is here: http://sukzessiv.net/x120e/
> Userspace is an up-to-date Ubuntu 11.04 beta (with bluez 4.91).
> 
> If there are any debugging steps that I could do or patches to try or
> revert, let me know. Unfortunately I can't do a proper bisect since
> the machine is a netbook type.

I guess strace of the pairing attempt would be helpful.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
