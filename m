Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2GSMzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:55:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab2GSMz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:55:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt
Date: Thu, 19 Jul 2012 12:55:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        Alexey Charkov <alchark@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz> <201207191228.48809.arnd@arndb.de> <76F764B079F92A4E843589C893D0A022C3812054@SERVER.prisktech.co.nz>
In-Reply-To: <76F764B079F92A4E843589C893D0A022C3812054@SERVER.prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191255.20366.arnd@arndb.de>
X-Provags-ID: V02:K0:S+zRdUYHjqVLKNRKKYwHYR0IPFnP1eIhV3NF2ev+623
 F14coqjxfWXcAYBpzZkFwmkicbi3bOLFNH6NzeQ3QKwoPgg/Is
 lLQH7Yc2f7LiFNhfwXMsS+8PQ5mlbgymaYkP+/cIoNsMafdeGz
 PmMfHYKBqFENO3rmyXEWvV1vgbGZB1aZYBpYiLUGuEop1gc35x
 ti+vE50ZhFak4oFN+ubEwiqOlplAf+KfiqiMjaPz0iLgAj/N7R
 rmz6xgp2RmVDoi40ZUpkZtDEMlVYHVoqOvplR5tCJncM5Oyqsb
 mdlVTAlrhzW6EJxb40vv/UtFBBWV6ufycKCDMxenjhSHHgjllk
 vlKfAt9FukagqtpdHWuM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2012, Tony Prisk wrote:
> Which brings us back to the original question (and raises another one) - can we assume yet that
> 'wmt' will be the vendor-binding for Wondermedia? Also, what are we going to use for VIA-based
> SoC's given that VIA is the ticker for VIACOM. 
> 
> I did do a bit of a search on some stock tickers - 'WM' is Waste Management Inc. on the NYSE.
> Presumably this would be as safe, or safer, than WMT (Walmart).
> VIACOM, being a media content company, seems unlikely to produce any hardware but its possible
> they will rebrand others hardware.

"wm" has the danger of being confused with Wolfson Microelectronics, but
they are already listed in the documentation as using "wlf".

I'd really like to hear other opions from people on the devicetree-discuss
list, but if nobody replies, I'd suggest we go with "via" and "wm".

	Arnd
