Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1EFDKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 23:10:13 -0400
Received: from nm9.bullet.mail.sp2.yahoo.com ([98.139.91.79]:31473 "HELO
	nm9.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752612Ab1EFDKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 23:10:11 -0400
X-Yahoo-Newman-Id: 625875.13955.bm@omp1015.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.ca;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Received:Date:From:To:Subject:Message-ID:Mime-Version:Content-Type:Content-Disposition:User-Agent;
  b=Qk0M5PjOgd6AB39FUx66K7CUek45MjFkYkKPLVvB03ZBUKJ9vReMI+aSRYdY90mM0i+ewtNTzKwvf59htB5SuHddGpAWN6pJhV4DDNYvj//bncS7V3i5yq72hoIE+Zk9goWTQUBwyUA2+qgO5b07JmfYMst54W+1l6p0eYcoT8s=  ;
X-Yahoo-SMTP: Ll_2CwGswBCmYyy8D5vkxPEWV_RIV9L47w--
X-YMail-OSG: R6ykP9kVM1k83rSQ_nHAfIPoTS7MMMy2ILWE_Sh362eLcXm
 qF3GrxwPcubiX847J0_vyHolPDeZyVR.ej6XHLJsPP46OYCUvzOj.xp2aQ9q
 K3nVARmDhdJuyLSAaKgDuhWqE4eXW1KS6R_WSzv0dsvgvdImmlcIAHXLdWfk
 IU9cTEeCYg_H2tigWamLMSv3LmwYiqH2Ept_sT_1SGsUcUmm1k_nqazBWQMo
 VccWqYyzHykgPMPoMZtDrIW2lvr5RudkpMJEnyk8Rg5iH2Q4CBCytTSQ36E7
 pPlP38KxoN5mZ70JOpjWOjap8SfB0tW8f6dkXhGZfbxvcdyRemID2oT12zx_
 30VwJhTzFUYTAvlrEma0bBVrM7c6e_nlwrv11z4I5
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 5 May 2011 23:10:06 -0400
From: William Park <opengeometry@yahoo.ca>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0xc8/0x140()
Message-ID: <20110506031006.GA16479@node1.opengeometry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI... here is kernel trace that I got while booting 2.6.39-rc6:

------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0xc8/0x140()
Hardware name: System Product Name
Modules linked in: powernow_k8 freq_table mperf snd_hda_codec_hdmi snd_hda_codec_analog raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx md_mod rt61pci rt2x00pci rt2x00lib mac80211 cfg80211 psmouse snd_hda_intel ppdev parport_pc snd_hda_codec snd_hwdep parport evdev k10temp forcedeth rfkill snd_pcm nv_tco eeprom_93cx6 snd_timer asus_atk0110 mac_hid hwmon i2c_nforce2 serio_raw snd rtc_cmos processor thermal soundcore snd_page_alloc sg fan button
Pid: 387, comm: kworker/1:1 Not tainted 2.6.39-rc6 #3
Call Trace:
 [<ffffffff81041eeb>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81055ba8>] ? worker_enter_idle+0xc8/0x140
 [<ffffffff81058d50>] ? worker_thread+0x1d0/0x3d0
 [<ffffffff81033640>] ? __wake_up_common+0x50/0x80
 [<ffffffff81058b80>] ? rescuer_thread+0x2e0/0x2e0
 [<ffffffff81058b80>] ? rescuer_thread+0x2e0/0x2e0
 [<ffffffff8105c7f6>] ? kthread+0x96/0xa0
 [<ffffffff81656ed4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8105c760>] ? kthread_worker_fn+0x170/0x170
 [<ffffffff81656ed0>] ? gs_change+0xb/0xb
---[ end trace 912cf20fdd777538 ]---

-- 
William
