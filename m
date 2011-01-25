Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1AYVhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:37:01 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:60971 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753402Ab1AYVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:36:59 -0500
Message-ID: <4D3F4277.20008@example.com>
Date: Tue, 25 Jan 2011 22:36:55 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Something is wrong in your source, David
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4789578203830841637
X-Ovh-Remote: 79.185.215.233 (adtd233.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, hello all,

David, when I apply your source from GIT to Linus source I get this in 
final part of the build process:

   (...)
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k.o
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k_hw.o
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k_common.o
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k_htc.o
   Building modules, stage 2.
   MODPOST 2690 modules
ERROR: "register_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "alloc_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "can_bus_off" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "close_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "free_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "unregister_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "alloc_can_skb" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "open_candev" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "can_get_echo_skb" [drivers/net/can/softing/softing.ko] undefined!
ERROR: "can_put_echo_skb" [drivers/net/can/softing/softing.ko] undefined!
WARNING: modpost: Found 24 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[2]: *** [__modpost] B³±d 1
make[1]: *** [modules] B³±d 2
make[1]: Opuszczenie katalogu 
`/usr/src/linus/linux-2.6-20110125-2155-pztidm'
make: *** [debian/stamp/build/kernel] B³±d 2


-- 
TV: "Grucha³a jest taka, ¿e cieszy siê z ka¿dego pchniêcia."
NP: Patrick O'Hearn - Beneath the Celestial Sphere
NB: 2.6.38-rc2-20110125-1848-ti+
