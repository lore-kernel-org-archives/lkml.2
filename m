Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1GXXLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:11:22 -0400
Received: from lo.gmane.org ([80.91.229.12]:44938 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab1GXXLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:11:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: [bisected regression] Partial breakage of forcedeth driver
Date: Sun, 24 Jul 2011 16:10:59 -0700
Message-ID: <4E2CA683.4010005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-189-60.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110705 Thunderbird/5.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi gang.

commit 3326c784c9f492e988617d93f647ae0cfd4c8d09
Author: Jiri Pirko <jpirko@>
Date:   Wed Jul 20 04:54:38 2011 +0000

    forcedeth: do vlan cleanup
    
    - unify vlan and nonvlan rx path
    - kill np->vlangrp and nv_vlan_rx_register
    - allow to turn on/off rx vlan accel via ethtool (set_features)
    
    Signed-off-by: Jiri Pirko <jpirko@>
    Signed-off-by: David S. Miller <davem@>

This commit causes networking trouble for my nForce-based motherboard.
(Details happily supplied if needed.)

I say 'partial' breakage because networking is not completely dead,
just limping very slowly :)

The simplest test is to ping any host (in my LAN or on the internet,
makes no difference).  The replies to my ping come at very irregular
intervals, ranging from normal to 5-10 seconds or so, seemingly at
random AFAICT.

I'm happy to try any patches, tests, whatever, to help fix this.

Many thanks!

