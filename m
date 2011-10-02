Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1JBPnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 11:43:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1JBPnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 11:43:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] Generic ARM fixes for randconfig
Date: Sun, 02 Oct 2011 17:42:16 +0200
Message-ID: <1412110.pVL3lEeEnX@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002153646.GX11710@n2100.arm.linux.org.uk>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de> <20111002153646.GX11710@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IPVE08xdFRra4/gOdu2E6kstrOQoTHEFzxhGB5B9Tcg
 IklIlTMAPIDbTmzRDVc54Cyh1U6VSeiEbrikOJDEz5XNsbi2Xg
 SAVQy+cnXdCG/+4gGsJjLRLIy6qpeAzQOmbdgYkS9/Xl+ycOHZ
 cCrw6Ejjz5+RXGFYm7kqirQraxIDB6z5x2rvaTXaa6IajD275Z
 Ym/NnVwUaq+D3Yh2GqlDWf0YH/eO3X5m0+6ASQYXQar7VA7Anl
 GJP1+vmdUlBVly9ZdyMIzOZDpnaejmdzPVbRdlVnB9b2nBCeId
 rtSlgqeY5FyPZk21K/2j6adDNIckYi7fF/QuPHbWG3OvM4tOWW
 0uFPh9nD0J0Wyw4Rlgu4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 16:36:46 Russell King - ARM Linux wrote:
> On Sat, Oct 01, 2011 at 09:21:49PM +0200, Arnd Bergmann wrote:
> > Please pull these into your tree, or alternatively cherry-pick the
> > ones that you are happy with if you disagree with some of them.
> 
> I think I'll merge all but the first from this - I think the first
> should be part of a cross-arch cleanup.

Ok, thanks!

I'll put the remaining patch into my 'randconfig/hacks' branch, which
already contains a number of other things that need a proper fix but
for which there is an easier circumvention.

Once all the low-hanging fruit are dealt with, I'll get back to that
branch.

	Arnd
