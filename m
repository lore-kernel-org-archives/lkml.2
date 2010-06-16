Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0FPIaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:30:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:47156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0FPIaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:30:12 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: roma1390 <roma1390@gmail.com>
Subject: Re: INFO: task khubd:271 blocked for more than 120 seconds.
Date: Wed, 16 Jun 2010 10:30:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc2-0.1-default+; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <4C18855E.5010508@gmail.com> <201006161022.32398.oneukum@suse.de> <4C188AEA.3010109@gmail.com>
In-Reply-To: <4C188AEA.3010109@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006161030.36000.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 16. Juni 2010 10:27:22 schrieb roma1390:
> Hello,
> 
> Oliver Neukum wrote:
> > Am Mittwoch, 16. Juni 2010 10:03:42 schrieb roma1390:
> >> Hello,
> >>
> >>
> >> We got this on our production system. Kernel: 2.6.26-2-amd64.
> >> This seems to be related with http://bugzilla.kernel.org/show_bug.cgi?id=13316 and still is open. Sadly to have such long standing bugs in common used subsystems like USB.
> >>
> > 
> > Under which conditions did you get this? Physical unplug, S3 or S4?
> > 
> > 	Regards
> > 		Oliver
> 
> this was normal operation (no unplug, no S3 or something like that). This is on-line
> server. There is posible issue with usb device itself or physical usb port. Which
> sometimes causes device disconections, reconnections.
> 
> Of course it's posible to fix on hardware level, but OS can't do such nasty things also.

Yes, this is a kernel bug. It would be helpful to have a bit more of context.
Could you post a bit more of your dmesg before the oops?

	Regards
		Oliver
