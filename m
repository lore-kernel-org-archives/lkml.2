Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0HaLWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:22:00 -0400
Received: from lucidpixels.com ([75.144.35.66]:44414 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0HaLV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:21:58 -0400
Date: Tue, 31 Aug 2010 07:21:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: adam radford <aradford@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
In-Reply-To: <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1008310717260.4858@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com> <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan> <alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Aug 2010, Justin Piszcz wrote:

>
>
> On Fri, 27 Aug 2010, Justin Piszcz wrote:


Problem persists during heavy I/O, different error this time:

[152904.636062] 3w-9xxx: scsi1: ERROR: (0x06:0x0036): Response queue (large) empty failed during reset sequence.
[152917.721865] 3w-9xxx: scsi1: AEN: INFO (0x04:0x0001): Controller reset occurred:resets=2.

--

syslog:Aug  6 05:58:19 p34 kernel: [    1.763002] 3w-9xxx: scsi1: AEN: INFO (0x04:0x0001): Controller reset occurred:resets=1.
syslog:Aug 20 07:30:41 p34 kernel: [1171646.371290] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
syslog:Aug 24 09:04:11 p34 kernel: [246703.526388] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
syslog:Aug 24 09:14:04 p34 kernel: [247295.662461] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
syslog:Aug 26 21:05:22 p34 kernel: [462727.945313] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
syslog:Aug 27 00:39:43 p34 kernel: [475586.575030] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.
syslog:Aug 31 05:53:03 p34 kernel: [152904.636062] 3w-9xxx: scsi1: ERROR: (0x06:0x0036): Response queue (large) empty failed during reset sequence.
syslog:Aug 31 05:53:03 p34 kernel: [152917.721865] 3w-9xxx: scsi1: AEN: INFO (0x04:0x0001): Controller reset occurred:resets=2.

--

It started happening on August 6th, this is around the same time I upgraded
to the 2.6.35 kernel, the 2.6.35 kernel according to kernelnewbies was
released on August 1, 2010:

http://kernelnewbies.org/LinuxChanges
Linux 2.6.35 has been released on 1 Aug, 2010.

http://marc.info/?l=linux-kernel&m=127419418304483&w=2

Adam Radford (2):
       3ware maintainers update
       3w-xxxx, 3w-9xxx: force 60 second timeout

I will go back to 2.6.34 and see if the problems persists.

Justin.

