Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1C3XMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:12:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab1C3XMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=o666axh3CFav80MadWn+JkpqEuGtH7E//BpLk+b4psXof4Zuntp8RohwNZnVYYaXbM
         3dz2MFSKta69mHK3j67ejANQa/4xEywDNrNy5V4nb4Re/x+eSC7KkVd5cS/SnH1b3RFW
         /ffhSe7ddRgay9Q596l/GWMDXkcLgklk7+BaY=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 30 Mar 2011 16:11:53 -0700
Message-ID: <AANLkTi=CmYAYO5awFvdcO07qcj6oiOV8B+NoYSEkddbF@mail.gmail.com>
Subject: compat-wireless for 2.6.38.2
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new stable update has been made so we get the extra stuff sucked in.
The vanilla release:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/compat-wireless-2.6.38.2-2.tar.bz2

And then this "-ns" release:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/compat-wireless-2.6.38.2-2-ns.tar.bz2

has these extra patches applied:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.38.y)$ ls -1
linux-next-cherry-picks/
0001a-ath9k_hw-Add-a-function-to-read-sqsum_dvc.patch
0001b-ath9k-Fix-a-PLL-hang-issue-observed-with-AR9485.patch
0001c-ath9k-Cancel-pll_work-while-disabling-radio.patch
0002-ath9k-Fix-incorrect-GPIO-LED-pin-for-AR9485.patch
0003-ath9k_hw-Read-noise-floor-only-for-available-chains-.patch
0004-ath9k_hw-Improve-idle-power-consumption-for-AR9485.patch
0005-ath9k_hw-Increase-the-wait-count-for-nf-load.patch
0006-ath9k_hw-fix-REG_SET_BIT-and-REG_CLR_BIT-for-multipl.patch
0007-ath9k-fix-stopping-tx-dma-on-reset.patch
0008-ath9k-disable-beaconing-before-stopping-beacon-queue.patch
0009-ath9k-improve-reliability-of-beacon-transmission-and.patch
0010-ath9k-fix-aggregation-related-interoperability-issue.patch
0011-staging-Fix-some-incorrect-use-of-positive-error-cod.patch
0012-staging-ath6kl-Fixing-a-NULL-pointer-exception.patch
0013-staging-ath6kl-Fixing-key-settings-for-WPA-WPA2.patch
0014-staging-ath6kl-Return-correct-scan-complete-status.patch
0015-staging-ath6kl-Fixing-target-crash-due-to-mismatch-c.patch
0016-staging-ath6kl-Fixing-driver-initialization-for-manu.patch
0017-staging-ath6kl-Consolidating-hardware-configuration.patch
0018-staging-ath6kl-Adding-support-for-txop-bursting-enab.patch
0019-staging-ath6kl-Fixing-a-memory-leak.patch
0020-staging-ath6kl-Fixing-a-memory-leak.patch
0021-staging-ath6kl-Add-configuration-for-excessive-TX-re.patch
0022-staging-ath6kl-Fixing-memory-leak.patch
0023-staging-ath6kl-Fixing-the-cached-copy-of-the-BSS-fil.patch
0024-staging-ath6kl-Adding-state-in-driver-to-track-the-s.patch
0025-staging-ath6kl-Fixing-accidental-overwriting-of-prob.patch
0026-staging-ath6kl-Fixing-disappearing-of-scan-list-due-.patch
0027-staging-ath6kl-buffer-overflow-in-SEND_FRAME-ioctl.patch
0028-staging-ath6kl-Eliminate-cfg80211-warnings.patch
README
mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.38.y)$ ls -1
pending-stable/
0006-ath9k-Fix-kernel-panic-in-AR2427.patch
0007-mac80211-initialize-sta-last_rx-in-sta_info_alloc.patch
0008-mac80211-fix-a-crash-in-minstrel_ht-in-HT-mode-with-.patch
0009-ath9k-fix-a-chip-wakeup-related-crash-in-ath9k_start.patch
backports
README
mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.38.y)$ ls -1
pending-stable/backports/
0010-iwlegacy-fix-bugs-in-change_interface.patch

  Luis
