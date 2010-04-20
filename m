Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0DTDKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:10:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0DTDKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:10:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: my KDE-4.4.2 Battery Monitor ppplet dislikes the ACPI changes in 2.6.34-rc3 betweeen f5284e7..cf90bfe
Date: Tue, 20 Apr 2010 05:10:47 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201004081812.10656.toralf.foerster@gmx.de> <201004081817.29561.toralf.foerster@gmx.de>
In-Reply-To: <201004081817.29561.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004200510.47642.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Toralf Förster wrote:
> 
> Toralf Förster wrote at 18:12:09
> > because now it tells me that my ThinkPad T400 has 0 cpus and 0 batteries
> > ...
> 
> FWIW : 
> 
> tfoerste@n22 ~/tmp $ grep "ACPI E" dmesg-2.6.34-rc3-00406-gcf90bfe
> ACPI Error: Null Object! Obj=(null) State=f676bc00 Num=0 
> (20100121/dswstate-183)
> ACPI Error (psparse-0537): Method parse/execution failed 
> [\_SB_.PCI0.LPC_.EC__.GBIF] (Node f70d4e28), AE_BAD_PARAMETER
> ACPI Error (psparse-0537): Method parse/execution failed 
> [\_SB_.PCI0.LPC_.EC__.BAT0._BIF] (Node f70d4d60), AE_BAD_PARAMETER
> ACPI Exception: AE_BAD_PARAMETER, Evaluating _BIF (20100121/battery-405)
> thinkpad_acpi: ThinkPad ACPI Extras v0.24

Does that still happen with -rc5?

Rafael
