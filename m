Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2EKNWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:22:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759816Ab2EKNWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:22:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH RESEND v8] gpio: Device tree support for LPC32xx
Date: Fri, 11 May 2012 13:22:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
References: <1336679838-30738-1-git-send-email-stigge@antcom.de> <201205111219.10025.arnd@arndb.de> <4FAD0A79.8040207@antcom.de>
In-Reply-To: <4FAD0A79.8040207@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205111322.15191.arnd@arndb.de>
X-Provags-ID: V02:K0:wtKuVUf8v/UY8Zo+Sowtje+InQVmiYvZZjJ+e1Pb0X1
 nCmvwF4s0/r0y2LEd+8Mu/fFZ3vGFA9RLSSHG33z2davB5EYLl
 WhznBQSyi2DC5J4FSp930OjGpD2gdkKaHpC+JsFDv9V53wXpNt
 esjVMvDYQYk5QvSr9ZbTM27RHdPoP6CATiwWgUcJB6q5FG38jO
 duc2tAu5szLIynjBsBfyTC1cSqF2eWrX9Z6aZYPcsJbH9ChlUW
 eBzAwiviXywd7mAeVG+I1uU6y9e1MxzAtdZidcEioPBw4YWr4e
 4LsX5BtKqOS5ivO9qO9bwCnxXN4/SISpm4I57KeLgwxQ+K2o7i
 7hShPuWFgT2uUbvVPGh8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012, Roland Stigge wrote:
> Right. Personally, I would be fine with either of my v8 (all banks in
> dt, referenced naturally by name) and v9 (one simple DT entry for the
> whole GPIO controller, integer index for referencing banks) patches.
> 
> Consider the DT-documented mapping in the latter case:
> 
>       0: GPIO P0
>       1: GPIO P1
>       2: GPIO P2
>       3: GPIO P3
>       4: GPI P3
>       5: GPO P3
> 
> Not too difficult and would also be acceptable, IMO.
> 
> So Arnd and Grant, please agree one of those and pick it. :-)
> 

Grant is maintainer for both GPIO and DT, so his opinion is what
counts in this case.
I was merely giving the background on how we got there so he
can make an informed decision.

	Arnd
