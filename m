Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0ECWEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:04:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43499
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178Ab0ECWEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:04:36 -0400
Date: Mon, 03 May 2010 15:04:42 -0700 (PDT)
Message-Id: <20100503.150442.140757825.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: mst@redhat.com, eric.dumazet@gmail.com, ebiederm@xmission.com,
       johannes@sipsolutions.net, therbert@google.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: show stopped status in sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272923093.27948.63.camel@localhost>
References: <20100503212423.GA15998@redhat.com>
	<1272923093.27948.63.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Mon, 03 May 2010 22:44:53 +0100

> On Tue, 2010-05-04 at 00:24 +0300, Michael S. Tsirkin wrote:
>> When debugging faulty hardware (in case of virt, faulty
>> emulation) I found it helpful to be able to examine
>> stopped status of the interface. The following patch makes
>> this visible in sysfs.
> [...]
> 
> This is a per-queue attribute and should not be associated directly with
> the netdev.

Right.
