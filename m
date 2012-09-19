Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab2ISU0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:26:39 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:48747
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807Ab2ISU0h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:26:37 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 16:26:37 EDT
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <87mx0lsv4d.fsf@spindle.srvr.nix>
Date: Wed, 19 Sep 2012 14:19:29 -0600
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com>
References: <87mx0lsv4d.fsf@spindle.srvr.nix>
To: Linux RAID <linux-raid@vger.kernel.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 19, 2012, at 12:52 PM, Nix wrote:

> So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
> Areca 1210 hardware RAID-5 controller 

Did you find this? Same controller family. Weird that this just shows up now, but perhaps instead of it being "bad hardware" out the gate, something's happened to it and now it's failing as you suspect.

http://www.xtremesystems.org/forums/showthread.php?276187-Raid-Locks-Up


Chris Murphy