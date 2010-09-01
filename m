Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0IAJff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:35:35 -0400
Received: from smtp.witbe.net ([81.88.96.48]:41081 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0IAJfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:35:33 -0400
Date: Wed, 1 Sep 2010 11:35:25 +0200
From: Paul Rolland <rol@as2917.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: rol@as2917.net
Subject: 2.6.36-rc2 : slabtop report 10170292 size-32 objects...
Message-ID: <20100901113525.04b356c5@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was surprised to see my machine using so much swap when I couldn't find
where all the memory was gone, and I checked quickly what slabtop had to
say, and found that one :

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
10172288 10171996  99%    0.03K  90824      112    363296K size-32

That makes is 10M active "size-32" entries ? but what is that ? What is
using the "size-32" ? And it this normal to see that on a laptop with 4G
RAM which is only running X, KDE, Compiz+emerald, +/-10 xterms and a
firefox which is closed as soon as it is no more used.

Before you ask :
[root@tux proc]# zgrep SLAB /proc/config.gz 
CONFIG_SLAB=y
CONFIG_SLABINFO=y
# CONFIG_DEBUG_SLAB is not set
[root@tux proc]# uptime
 11:34:50 up 6 days, 20:30, 13 users,  load average: 1.42, 1.35, 1.23

so that may limit the actions or informations I can collect, but any
details you want, please feel free to ask.

Regards,
Paul
