Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030774Ab2CTQkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:40:49 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:26981 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2CTQks (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:40:48 -0400
X-Greylist: delayed 2268 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2012 12:40:47 EDT
X-Envelope-From: vesej3am@mail.kolej.mff.cuni.cz
Date: Tue, 20 Mar 2012 17:02:51 +0100
From: Jozef Vesely <vesely@gjh.sk>
To: linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: possible bug (or not clear coding) in uvc_v4l2.c
Message-ID: <20120320160251.GA79846@mail.kolej.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day, 

I am sorry to disturb you, I have been reading through uvc driver source 
and this caught my eye:
http://lxr.linux.no/#linux+v3.3/drivers/media/video/uvc/uvc_v4l2.c#L671

678: int pin = 0;
...
689: } else if (pin < selector->bNrInPins) {
...
690: pin = selector->baSourceID[index];

pin is always 0 in the comparison, was this intended?
(wasn't the line 690 supposed to be before the comparison?
or the index to be compared  to bNrInPins?)

Please excuse me wasting your tine if it is a total nonsense. 
Sincerely 

Jozef Vesely
vesely@gjh.sk

PS: I am looking for a reason why MJPEG stopped working
on my cameras (long time ago), any hints?
