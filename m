Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab1FXNuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:50:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab1FXNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:50:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 8/10 v2] Generic Watchdog Timer Driver
Date: Fri, 24 Jun 2011 15:49:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172637.GI3441@infomag.iguana.be> <201106182109.14520.arnd@arndb.de> <20110622200009.GC26745@infomag.iguana.be>
In-Reply-To: <20110622200009.GC26745@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241549.32601.arnd@arndb.de>
X-Provags-ID: V02:K0:SnBrpgStVJ0PnBap2ql9+gRwjubJju8ZdoaCOwut8iz
 j1BlkNPAG9DlAEJfjwFK9xtMhjqn5znFTk7k8Jh1NYpbL9j/P3
 wJy5WFQVZLEgoYIE6V9FLzWnhtlT8vHJbS+R/lMHSt/pDg16J3
 bzsKt6NHjfmtY0Iw+fA/8PZ1CcmnRe/+HgyMTZiAO3MZQijupm
 eI6dSgj4jsNlE4DXu33gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 22:00:09 Wim Van Sebroeck wrote:
> prefer to not do that for following reasons:
> 1) I deliberately splitted the framework in a series of patches, so that people
> understand better what the differen developmentt steps have been historically
> and/or logically. By splitting it, I hope that people will understand better
> why the API is what it is.
> 2) most watchdog drivers don't do this yet. So this teaches existing device
> driver writers also that this is a possible feature.
> 

Ok, makes sense.

	Arnd
