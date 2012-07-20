Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2GUIt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 04:49:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2GUIs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 04:48:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [GIT PULL] ARM: LPC32xx: Core updates
Date: Fri, 20 Jul 2012 22:19:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
References: <50094A0E.4070006@antcom.de>
In-Reply-To: <50094A0E.4070006@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207202219.40319.arnd@arndb.de>
X-Provags-ID: V02:K0:fSJcMIAPfBZwxgxZkCpeGCKY8vYL9sF5PZaDbPL5PFx
 ddZ5NtzUcmA3dVflZbAVWbrMrrC1jVKc+O/FrixOZ5uTsRnSix
 1H2W7+rzT6Y1olwoCaLH/haN91MWx5cUuO6YFMV8MJMsV2jaRZ
 97ZtbFTQtiuZu95yCZlzvVKTUd74PyJvPM7oVpz2qmcx0XfDln
 U6rrJlNIcAPcHxhCTYPi2JJ2toysNM2mvx1ZMfSdWIPE4jVYLV
 o/kZMXj12FO347+zn2P3EOP2g9DpJdPfK9IL/OYMsk+ZLZA7Yp
 8oGvybH8WO1UmJ7KVD/CbHkBvkwSqjH1+vfrnh98XTWKbPaCgA
 gpLrC76Uv4jJVwgU+3x8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2012, Roland Stigge wrote:
> Hi Arnd and Olof,
> 
> this LPC32xx core update (branch lpc32xx/core2) builds upon the
> previously provided lpc32xx/core-fixes. Basically including PWM support
> (for the PWM driver from Alexandre already in the pwm tree), and
> CPU ID.

Pulled both branches into the sames ones as earlier respective ones.
Note that you don't actually have to start a new branch when you
add patches for the same topic, you can just add stuff on top,
whichever works best for you.

It would be nice if you can start sending tags rather than branches,
because that lets you put the changeset text right into the tag
so I don't have to copy it into the merge text manually.

	Arnd
