Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2IXMnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:43:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2IXMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:43:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the arm-soc tree with the omap_dss2 tree
Date: Mon, 24 Sep 2012 12:43:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <20120924195305.588277e94ce701abc5e5a6c5@canb.auug.org.au>
In-Reply-To: <20120924195305.588277e94ce701abc5e5a6c5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209241243.39462.arnd@arndb.de>
X-Provags-ID: V02:K0:avnr9qPa3jBZiQvx4qfmld1ajzA4rvcA3p62waS+gfd
 iuC9RujhiSQAdV2ZKeFhbcQ0Sy4hetamFSypCSL9JMFbjpvXe/
 bjBS1GB70VwJ10W816fJ0W3PYGWNB47K46PuurEH0hx5pDo8Ck
 pI7WCdKqhbY+6kT4rL0xmo/LWPsUJKeE0PK1YD4zXX6jOLEpLG
 zcIdAe4uTWUOdsKSqbTY5VIn/lgxIa0dNQyF2UA9IuDN3QKmpp
 4QX0vPVv7JijmGqnrVCVIlpfenhoLrv90PZROTpogTAlxgYyfl
 WiT6qHmwhxURgT5jdmIKfaJyFnOH3vJ+T8HoRPF/+qiWJfLnhW
 SobuOYU0jwmdV26FmrKs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/video/omap/lcd_ams_delta.c between commit 9586778de558 ("OMAPFB1:
> remove unnecessary includes") from the  tree and commit e27e35ec735f
> ("ARM: OMAP1: Move board-ams-delta.h from plat to mach") from the arm-soc
> tree.
> 
> The latter removed a superset of the former (as far as include files is
> concerned), so I used that and can carry the fix as necessary (no action
> is required).
> 

Hi Stephen,

I looked at all your reports and your fixes are looking good to me.

I'm already building all ARM defconfigs now and have fixup patches for the
instances that went wrong or introduced new warnings, I'll do that again
on top of today's linux-next tree.

The merge window is going to be fun with all those conflicts, but I don't
have a better idea either.

	Arnd
