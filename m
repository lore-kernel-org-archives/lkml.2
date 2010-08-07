Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378Ab0HGHyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:54:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0HGHyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:54:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: TTY: warning in tty_lock on 2.6.35+gregkh tree
Date: Sat, 7 Aug 2010 09:54:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
References: <20100807192122.2005c856@tom-lei>
In-Reply-To: <20100807192122.2005c856@tom-lei>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008070954.08613.arnd@arndb.de>
X-Provags-ID: V02:K0:60nlKiMIChSiX71F1SWTUtYFiRiFl1L302jBe1OFPyS
 vTI+6SnKI2q5vQOPnF+pJjuA9SM7g1De+SgIfU/k7+1KrH09YM
 pduqJWAZ1MshKRkBEvj43ADokJeKf8/bCY9hNJ3nVPNiWj+lmS
 DxDO6hVZglUMAkKnGW8WCHenImTzvhWhIQUpe907sDYBzQBdU+
 5MIXBY16vCFBbOipVKcyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 August 2010, Ming Lei wrote:
> Following the ttty warning during kernel boot, seems it is for a long time
> in gregkh's tree.

The fix for this is in the bkl/core tree, meaning it doesn't show up
in the linux-next tree.

The warning by itself is harmless, so there was no strict need to
coordinate this better. In fact, with the removal of the optional
BKL behavior, I believe the warning is now gone from the tty
tree as well.

	Arnd
