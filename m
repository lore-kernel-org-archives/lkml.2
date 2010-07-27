Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0G0IzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:55:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0G0IzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Oo35yB00J2Zhm9/Jv4SVdvqdfyG5+rw7XpO6Eh/Z+7p41oZj86+i0LE7+llJDCeNEI
         KPc9AXeFVLDYdwwtR91ds3E5XkZhg02Sy6zEqTKv+VEVi1FJJe4WSNpuKfwi/xGNnikR
         vk399CYlQ3cQqL7x8hv/v50oGmDvoa/zhXqHw=
Subject: Re: ixgbe->bonding->vlan->bridge->ebtables&iptables causes memory
 corruption
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Gyorgy Jeney <nog.lkml@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimEYWiz4d-go6PszKnR0U29FYfjvHeLbPavi-RH@mail.gmail.com>
References: <AANLkTimEYWiz4d-go6PszKnR0U29FYfjvHeLbPavi-RH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 10:55:10 +0200
Message-ID: <1280220910.2827.1.camel@edumazet-laptop>
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

Seems tricky :(

Could you send  your {eb/ip}tables rules ?



