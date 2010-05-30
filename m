Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0E3Heg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 03:34:36 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:54988 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0E3Hee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 03:34:34 -0400
Message-ID: <4C021507.6020703@xs4all.nl>
Date: Sun, 30 May 2010 09:34:31 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
References: <4BFA52C3.4080006@xs4all.nl> <20100526120236.4a849b5b.randy.dunlap@oracle.com>
In-Reply-To: <20100526120236.4a849b5b.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Have you enabled ACPI in the BIOS and kernel config? AFAIK, HPET
> timers, need some backup timers, for HPET to be enabled.

ACPI is enabled. APM is disabled.

Epia LT BIOS is at 1.01 presumably. BIOS update to 1.03  fails as
vf-1.02.exe, presumably due to freedos, does not recognise the VIA board
and complains about it.

Also due to board swap last year it can be the case that HPET has so far
not worked at all on EPIA LT.

The board has VIA C7 CPU and VIA CX700M2 Unified Digital Media IGP
chipset which supports HPET.

Can it be that the kernel lacks support for CX700 hpet?
Or is it a matter of getting the BIOS upgrade to work?


Udo
