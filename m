Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2DSIZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:25:00 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:33055 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab2DSIY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:24:57 -0400
Message-ID: <4F8FCBD8.5070106@msgid.tls.msk.ru>
Date: Thu, 19 Apr 2012 12:24:56 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-acpi@vger.kernel.org
Subject: Re: Recent intel Cedarview motherboards: does not poweroff
References: <4F8B1F64.9030502@msgid.tls.msk.ru>
In-Reply-To: <4F8B1F64.9030502@msgid.tls.msk.ru>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.04.2012 23:20, Michael Tokarev wrote:
> Hello.
> 
> Intel produced a set of very nice mini-ITX boards with new Cedarview
> Atom CPUs onboard -- D2500CC, D2700MUD, D2800MT etc.  Apparently
> all of these boards have issues powering off from linux.
> 
> Here's the last few lines left on the screen when the system should
> turn the power off:
> 
> ACPI: Preparing to enter system sleep state S5
> ACPI Error (psargs-8359): [\_SB_.PCI0.LPCB.TPM_.PTS_] Namespace lookup failure, AE_NOT_FOUND
> ACPI Error (psparse-8537): Method parse/execution failed [\_PTS] (Node f703c504), AE_NOT_FOUND
> Disabling non-boot CPUs ...
> CPU1 is now offline
> SNP alternatives: switching to UP code
> Power down.
> _
> 
> 
> The cursor is blinking, and power staus on.
> 
> Is there anything can be done with this?

Anyone know what's going on?  Is it a BIOS problem?  Linux problem?

Thanks!

/mjt
