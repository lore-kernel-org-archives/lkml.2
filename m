Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0G0ObX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:31:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35794 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0G0ObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o/K4V+d38GF+mld3IoCtWijS8CdXhv/NsVq6o/KoBrDKSbFxxbmuCsHESJs9KxqLIe
         rSRv0YxbMMH9duNiKO/wJeSxlJSSWPT5kPzFPayD7Au2Ib4OBRy32kRzsVtwz7gEtfxq
         EkEPUAsddKpFIip3uzyOn4rC8bzXOMUjPQghg=
Subject: Re: ixgbe->bonding->vlan->bridge->ebtables&iptables causes memory
 corruption
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Gyorgy Jeney <nog.lkml@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimEYWiz4d-go6PszKnR0U29FYfjvHeLbPavi-RH@mail.gmail.com>
References: <AANLkTimEYWiz4d-go6PszKnR0U29FYfjvHeLbPavi-RH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 16:31:17 +0200
Message-ID: <1280241077.2827.327.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 27 juillet 2010 à 09:15 +0200, Gyorgy Jeney a écrit :
> Hi,
> 
> I  have a rather interesting network setup here.  First I have a dual
> 10Gbit ixgbe ethernet card, being bonded into one link, on which we
> run a number of vlans, which are bridged with various virtual
> machines.  Now, to protect the box itself and the virtual machines I
> have a set of iptables and ebtables rules.  Whenever one of the
> virtual machines start the kernel, which is 2.6.35-rc6, will reliably
> panic.
> 
> This error needs both ebtables and iptables rules, without either one
> or the other, things seem to work quite well.
> 
> The errors and backtraces are many and long, so I attached the full
> dmes output, please say if you need more.
> 
> nog.

Not related to your crashes, but I wonder how
net/bridge/netfilter/ebt_vlan.c is supposed to work with hw accelerated
vlans...



