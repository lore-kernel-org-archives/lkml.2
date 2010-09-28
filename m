Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842Ab0I1AHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:07:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57599 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab0I1AHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=K0vD8ePt2sgt04R1j5F/gGboGgKQ6hYXiYm3277lpNCWt6yAS4SH8uYle+iP7My/Ou
         vbEZsu15Ag4s8goOu+loetrBJybhNU8/jjboCbtGL/qpq0Jloh8eXAjKb65OcvXP72g3
         ZifvongE4qwFspX+BwlFu/re/YwAgb2l4RNCA=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 17:06:44 -0700
Message-ID: <AANLkTi=US_gs1fXiZiyZuEMOf8zVtXZzXs+GKX2vBsTf@mail.gmail.com>
Subject: compat-wireless 2.6.36-rc5-2-s released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus released 2.6.36-rc5 a few days ago, I've been waiting to kick
out a new stable release for compat-wireless once some patches were
applied but those stable patches never came so instead I've sucked
*all* the pending stable patches from linu-next.git, threw them into
compat-wireless-2.6.36-rc5 and produced a new tarball. This is a
stable  [1] compat-wireless-2.6.36-rc5-2-s [2], the "-s" postfix here
annotates that pending-stable fixes have been applied on top of the
vanilla Linus release. Please report any issues ASAP. For details on
changes you can refer to the ChangeLog-2.6.36-rc5-wireless [3].

The list of pulled in pending-stable patches from linux-next.git are:

0001-p54usb-fix-off-by-one-on-CONFIG_PM.patch
0002-mac80211-Fix-signal-strength-average-initialization-.patch
0003-ath9k-fix-spurious-MIC-failure-reports.patch
0004-ath9k_hw-handle-rx-key-miss.patch
0005-mac80211-use-correct-station-flags-lock.patch
0006-ath9k-fix-power-save-race-conditions.patch
0007-ath9k-fix-regression-on-beacon-loss-after-bgscan.patch
0008-ath9k-fix-enabling-ANI-tx-monitor-after-bg-scan.patch
0009-mac80211-add-helper-for-reseting-the-connection-moni.patch
0010-mac80211-reset-probe-send-counter-upon-connection-ti.patch
0011-mac80211-reset-connection-idle-when-going-offchannel.patch
0012-mac80211-make-the-beacon-monitor-available-externall.patch
0013-mac80211-disable-beacon-monitor-while-going-offchann.patch
0014-mac80211-send-last-3-5-probe-requests-as-unicast.patch
0015-ath9k-fix-regression-which-prevents-chip-sleep-after.patch
0016-ath9k-fix-regression-which-disabled-ps-on-ath9k.patch
0017-wext-fix-potential-private-ioctl-memory-content-leak.patch
0018-ath9k-fix-an-aggregation-start-related-race-conditio.patch
0019-ath9k-clean-up-fix-aggregation-session-flush.patch
0020-atl1-fix-resume.patch
0021-mac80211-fix-use-after-free.patch
0022-mac80211-clear-txflags-for-ps-filtered-frames.patch
0023-ath9k-Fix-tx-struck-state-with-paprd.patch

compat-wireless code metrics

    494754 - Total upstream lines of code being pulled
      1708 - backport code changes
      1470 - backport code additions
       238 - backport code deletions
      5990 - backport from compat module
      7698 - total backport code
    1.5559 - % of code consists of backport work
       363 - Code changes brought in from pending-stable
       190 - Code additions brought in from pending-stable
       173 - Code deletions brought in from pending-stable
    0.0734 - % of code being cherry picked from pending-stable

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.36-rc5
compat-wireless release: compat-wireless-v2.6.36-rc5-2-1-gf2e8f16-s

This release goes tests compiled and load tested against ath9k with a
AR9280 on 2.6.32. Please report any issues.

 Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-rc5-2-s.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/ChangeLog-2.6.36-rc5-wireless
