Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0HZRtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:49:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0HZRtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=Tq7YHitUus/LGHL0QCnzyZoIWU0A2+qv8guwzhIw52kXbxEEaDnhEUsG1yllqMQx0B
         akWEel+MVLpeXZgA/659Xx5NxSn+vWSHAW2Ufh60sQt4QGix18TrKU1tku0IgMDeGVeC
         8dybmBjxJiJObTN/xztVHbtzTAzv4TgfOwqp4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [REGRESSION] [2.6.36-rc2] hp-wmi: probe of hp-wmi failed with error -22
Date: Thu, 26 Aug 2010 19:49:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008261949.12608.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good kernel: 2.6.35
Failing kernel: 2.6.36-rc1, 2.6.36-rc2

Dmesg says:
root@gumis:/home/maciek# dmesg | grep -i hp-wmi
[    5.489731] hp-wmi: probe of hp-wmi failed with error -22

lsmod says, that wp-wmi module was loaded:
root@gumis:/home/maciek# lsmod | grep -i hp
hp_wmi                  4637  0 
rfkill                 11448  5 bluetooth,cfg80211,hp_wmi

rfkill list shows:
root@gumis:/home/maciek/kernel.org/2.6.36-rc2# rfkill list
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
        
Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.36-rc2/hp_wmi/dmesg-2.6-36-rc2.txt
config:
http://unixy.pl/maciek/download/kernel/2.6.36-rc2/hp_wmi/config-2.6.36-rc2

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
