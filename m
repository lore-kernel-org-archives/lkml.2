Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1G1NlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:41:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36599 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1G1NlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:41:13 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: walt <w41ter@gmail.com>
Subject: Re: [bisected regression] Partial breakage of forcedeth driver
Date: Thu, 28 Jul 2011 15:41:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4E2CA683.4010005@gmail.com>
In-Reply-To: <4E2CA683.4010005@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107281541.09069.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 25 lipca 2011 o 01:10:59 walt wrote:
> Hi gang.
> 
> commit 3326c784c9f492e988617d93f647ae0cfd4c8d09
> Author: Jiri Pirko <jpirko@>
> Date:   Wed Jul 20 04:54:38 2011 +0000
> 
>     forcedeth: do vlan cleanup
> 
>     - unify vlan and nonvlan rx path
>     - kill np->vlangrp and nv_vlan_rx_register
>     - allow to turn on/off rx vlan accel via ethtool (set_features)
> 
>     Signed-off-by: Jiri Pirko <jpirko@>
>     Signed-off-by: David S. Miller <davem@>
> 
> This commit causes networking trouble for my nForce-based motherboard.
> (Details happily supplied if needed.)
> 

[...]
I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=40272
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
