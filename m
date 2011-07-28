Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1G1OrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:47:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47806 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1G1OrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:47:22 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: David Miller <davem@davemloft.net>
Subject: Re: [bisected regression] Partial breakage of forcedeth driver
Date: Thu, 28 Jul 2011 16:47:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: w41ter@gmail.com, linux-kernel@vger.kernel.org
References: <4E2CA683.4010005@gmail.com> <201107281541.09069.maciej.rutecki@gmail.com> <20110728.064245.1432029423461356975.davem@davemloft.net>
In-Reply-To: <20110728.064245.1432029423461356975.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107281647.17948.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 28 lipca 2011 o 15:42:45 David Miller wrote:
> From: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date: Thu, 28 Jul 2011 15:41:08 +0200
> 
> > On poniedziałek, 25 lipca 2011 o 01:10:59 walt wrote:
> >> Hi gang.
> >> 
> >> commit 3326c784c9f492e988617d93f647ae0cfd4c8d09
> >> Author: Jiri Pirko <jpirko@>
> >> Date:   Wed Jul 20 04:54:38 2011 +0000
> >> 
> >>     forcedeth: do vlan cleanup
> >>     
> >>     - unify vlan and nonvlan rx path
> >>     - kill np->vlangrp and nv_vlan_rx_register
> >>     - allow to turn on/off rx vlan accel via ethtool (set_features)
> >>     
> >>     Signed-off-by: Jiri Pirko <jpirko@>
> >>     Signed-off-by: David S. Miller <davem@>
> >> 
> >> This commit causes networking trouble for my nForce-based motherboard.
> >> (Details happily supplied if needed.)
> > 
> > [...]
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=40272
> > for your bug report, please add your address to the CC list in there,
> > thanks!
> 
> It's fixed already in Linus's tree as of a few minuts ago.

Thanks. Closing bug.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
