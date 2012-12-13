Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2LMO7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:59:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab2LMO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:59:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [TRIVIAL PATCH 11/26] powerpc: Convert print_symbol to %pSR
Date: Thu, 13 Dec 2012 11:58:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <trivial@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <cover.1355335227.git.joe@perches.com> <8c901014a0f571011023ed98b9a22bc690925b73.1355335228.git.joe@perches.com>
In-Reply-To: <8c901014a0f571011023ed98b9a22bc690925b73.1355335228.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212131158.46055.arnd@arndb.de>
X-Provags-ID: V02:K0:TTuXYtWznOkVb+tbxdvAq62nqZkfmpH28nYhuI3PGCj
 ZfVrr3G1xp1glCbKLL4eHJkWI089LELoV1twXiSbJritB63pkB
 9VKIrVwCbHAp+/sK9/SKz/iwQOcCYOMOef7peme4ivw/I//dyR
 tLIZ7Xp7vgr2vNCk2T/LZUyjLFXrARKHymtXhQqsaXjtNE26Rq
 gZ9vzJTf1aDgex1I1ayjGXRnZLtaD7ykCM93hWGIcHaVSqAWrF
 8zvaLXrCg1uKXuQZW24Mgr1vgvJtMeq3QKkszwMJsAnhcnTF7W
 lYKeisbzBEasPvCFbSU2BefFAoEJAHpIRFHHRcgcR1Ad7EZ9rp
 e38gY8kUNfwWtcL9JC1A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2012, Joe Perches wrote:
> Use the new vsprintf extension to avoid any possible
> message interleaving.
> 
> Convert the #ifdef DEBUG block to a single pr_debug.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

nice cleanup!

Acked-by: Arnd Bergmann <arnd@arndb.de>
