Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1IAHIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 03:08:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1IAHIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 03:08:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: over-ride csum_partial_copy_nocheck, etc.
Date: Thu, 01 Sep 2011 09:07:42 +0200
Message-ID: <1664902.8eP1aWlL1O@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110831223519.GA14535@codeaurora.org>
References: <20110831223519.GA14535@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ecXhmidLANbngwydRXm8KhAlRuc1mvNOL7+XEkV4HU9
 4MbwP0r+WWXhFcrVzwjnTgd87GjR+Lo71ZAIGccC4koNyPCRkU
 Olo0HdP8pdP30dZ+HWSW38JiY+pAXG1sG/2X8SnUqdIXdFnJjO
 0VEBzh/JKSxV11tNMEMV/sWFeDdIwDYI+yIfOrB4KB8Bev807R
 SkZGuswGma9Wbdv+L+1ZRTaFb/h6zNIcts4U99FVj4qlLgSlXB
 08xlRrNRe+aLc6NXigHBk7oE0N6lQKgfroC056lYZlWNzhKpq+
 CYWWomprrsL+6HPgB2bkJbpc8O2ShFrYdoKzSSvMKQkBNjz15r
 TGIVCeojyIPXnQ+zsexI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011 17:35:19 Linas Vepstas wrote:
> There are plausbile reasons for architectures to provide their own
> versions of csum_partial_copy_nocheck and csum_tcpudp_magic. 
> By protecting these, the architecture can still re-use the 
> asm-generic checksum.h, instead of copying it.
> 
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Please add the patch to your hexagon patch set.

	Arnd
