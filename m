Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2DJMhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:37:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389Ab2DJMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:37:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>
Subject: Re: [PATCHv5 0/3] bmp085: add support for bmp18x chip
Date: Tue, 10 Apr 2012 12:36:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, stefan.nilsson@unixphere.com,
        broonie@opensource.wolfsonmicro.com, christoph.mair@gmail.com
References: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
In-Reply-To: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204101236.53406.arnd@arndb.de>
X-Provags-ID: V02:K0:nbtJ7anWwmW0Oy72JJNWDxxULdEQ6i3GSZu+HTVrB9i
 6xQbAVRvpcmdPpAheiGCidUa5epxu7F2gPfSC/rBlfkYZ0b/rp
 1hrCtXAeng0PWqVxbO9MaLRD4daNolLHdS4jP/knPBzoqBbGxA
 dx6CtbWMclnAhgFn9qu7D09YFc5kju3Z3KYFJOU1+a3mS3sE4D
 NrbNOBfCJ4OjXZ+O8q100Xeq20dcjA0z3O06Mrolon0QcGH4rr
 /pxKY/1A3rFG+Lovrxyu4YBsgCts2ZOonn+k2mCJFj0KoFN7Wq
 VxvXJLkCB3N4k9xg65iXz0w60TtMnMz39kEPKuXNt29sqs9roq
 jCuHd0Zm63tclmJNXLJs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Eric Andersson wrote:
> Hi,
> 
> This is version 5 of the patch-set that adds support for the latest pressure
> sensors from Bosch Sensortec.
> 
> Changes from last version:
> - Added "bosch" to vendor-prefixes.txt

As for the previous version:

Looks all good to me now,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
