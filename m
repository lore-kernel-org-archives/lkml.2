Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0LMWEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:04:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44585 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab0LMWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Fm0eDpUgfYLoCU5enoOzX+oKqJZPtXsSJ6tA+PyzKO6Jq4DCEvHzTCM6WiEXMU78Vv
         rRiSQKmDK9NgleLp8ERiEbG0R0aqHoWnMaK457oghNoIC/U8BHdq3mvhz1cLNtk6+BNk
         ajHMIPynhotjVK87bLCfzZI80l941+hFCfK2U=
Message-ID: <4D069853.5020803@gmail.com>
Date: Mon, 13 Dec 2010 22:04:03 +0000
From: Iain Paton <selsinork@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jengelh@medozas.de, agruen@suse.de, netfilter@vger.kernel.org,
        eparis@redhat.com, linux-kernel@vger.kernel.org, schwab@redhat.com,
        laforge@netfilter.org, andi@firstfloor.org
Subject: Re: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
References: <201008301258.33113.agruen@suse.de>	<alpine.LNX.2.01.1008301502280.19931@obet.zrqbmnf.qr>	<alpine.LNX.2.01.1010060804580.8631@obet.zrqbmnf.qr> <20101005.231045.226758916.davem@davemloft.net>
In-Reply-To: <20101005.231045.226758916.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Someone has to first add the types to linux/types.h, and that doesn't
> go through my tree.

Since the changes to linux/types.h got added in 79b5dc0c64d88cda3da23b2e22a5cec0964372ac is there any chance of the linux/if_ppp.h 
changes making it into 2.6.37 ?

Iain
