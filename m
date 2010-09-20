Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0ITJPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:15:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab0ITJP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:15:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the bkl-trivial tree with the mmc tree
Date: Mon, 20 Sep 2010 11:15:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Chris Ball <cjb@laptop.org>
References: <20100920145817.71fa0c35.sfr@canb.auug.org.au>
In-Reply-To: <20100920145817.71fa0c35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201115.25673.arnd@arndb.de>
X-Provags-ID: V02:K0:RWw3ulmB9RiayE5GFfCvv9lBex7rhhSm6Gj3QiDXp9L
 y+DrKdt9pzfOqFHzkONAttDGBKwCVqz72C4XMwJR7Vv3wuGO84
 Wz8hk8/rZ6ZCrthCNvAP9ERqxiwfVFJuL/UOFJjBHxrQ/DJGRc
 GaGy+NBWcG8MbHznoLMwBf7p2+bDWHDFS/ei43fkfkGNovmgq/
 /FjSwJQLenWnfd322GPBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 September 2010, Stephen Rothwell wrote:
> Today's linux-next merge of the bkl-trivial tree got a conflict in
> drivers/mmc/card/block.c between commit
> 28280d210bacf6788a5e4b12c5a9430bd50860b4 ("mmc: make number of mmcblk
> minors configurable") from the mmc tree and commit
> 5778067afcfd8b718ffc3744c25fdd194fc886a1 ("block: autoconvert trivial BKL
> users to private mutex") from the bkl-trivial tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good, thanks!

Chris, do you want to take my patch into your tree instead? Or even better
you could figure out if the BKL is actually needed there and remove it
otherwise so we don't need to introduce the mutex here.

	Arnd
