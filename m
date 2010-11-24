Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0KXROY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:14:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37584
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868Ab0KXROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:14:23 -0500
Date: Wed, 24 Nov 2010 09:14:49 -0800 (PST)
Message-Id: <20101124.091449.189711438.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: andi@firstfloor.org, vegard.nossum@gmail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, eugene@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] af_unix: limit unix_tot_inflight
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290611906.3464.66.camel@edumazet-laptop>
References: <1290590335.3464.24.camel@edumazet-laptop>
	<877hg2g4re.fsf@basil.nowhere.org>
	<1290611906.3464.66.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 24 Nov 2010 16:18:26 +0100

> 4) If we autotune a limit at boot time as a lowmem percentage, some guys
> then want a /proc/sys/net/core/max_unix_inflight sysctl , just for
> completeness. One extra sysctl... 
> 
> I cant see valid uses but programs designed to stress our stack.

I agree completely with Eric's analysis.

I would even consider setting this threshold lower. :-)

Anyways, consider Eric's patch applied.
