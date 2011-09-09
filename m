Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab1IIIRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:17:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab1IIIRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:17:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3 22/36] Hexagon: Add locking types and functions
Date: Fri, 09 Sep 2011 10:17:18 +0200
Message-ID: <119603683.IkWCJFkTsl@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010916.801809244@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.801809244@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QGAyzuz23TFj7nvq2fraHpfWwfrcCTXHhhOd21KkaKx
 OmwAr3KKIlqpMZ/TuMGZ7MluQot5VSQNlEosy+sBeNfuaxa1Xk
 VamxUDbTKZSVdGMcFLqYeBjf7SwGVolpH2us2BHdgYLbr7i3S/
 Cpo4ORTfxvQMFGBIrmp6/SZ91KgfXXPrDIL69h6LqSBi7x7RUP
 hjY6GOo5BYEF4n/iiywzeo/rxXH8xjKoyWQiUK4DjVNi8jSQdT
 fReAAQpzk3n8HIQGinH9A7xhjB9msrwfE4QVKto4fL/nxax/mb
 FkKJHNWpdQE7BxXLI6j6E1EmdLV9ivW8+rqJZ6Z76JhhoHqUcS
 xkJKi/bFZ/enXsG/lO4I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:09:09 Richard Kuo wrote:
> Moved rwsem to asm-generic.  Will submit a subsequent patch for PPC
> use it from the new location.

Excellent, thanks!
 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
