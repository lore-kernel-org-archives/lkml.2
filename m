Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0JFGKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:10:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36755
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474Ab0JFGK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:10:29 -0400
Date: Tue, 05 Oct 2010 23:10:45 -0700 (PDT)
Message-Id: <20101005.231045.226758916.davem@davemloft.net>
To: jengelh@medozas.de
Cc: agruen@suse.de, netfilter@vger.kernel.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org, schwab@redhat.com, laforge@netfilter.org,
        andi@firstfloor.org
Subject: Re: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.01.1010060804580.8631@obet.zrqbmnf.qr>
References: <201008301258.33113.agruen@suse.de>
	<alpine.LNX.2.01.1008301502280.19931@obet.zrqbmnf.qr>
	<alpine.LNX.2.01.1010060804580.8631@obet.zrqbmnf.qr>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Wed, 6 Oct 2010 08:05:52 +0200 (CEST)

> Dave, you liked this too, but I don't see it in net-next yet. Was there 
> some sort of holdup?

Someone has to first add the types to linux/types.h, and that doesn't
go through my tree.
