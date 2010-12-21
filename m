Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0LUUVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:21:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49921 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0LUUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=O8XYUA/ztmPuXbaAnhIKsqWtRYPKz5/laCDJz6suCVF/D2VasU4rvh7vck4M5U17OD
         deY4dN2pm580C4Wekg6acVcSJTTRh2G0OttbucqKswv5klsRw8NuZKzSijMyGb2NWm+v
         noXAz1tWX8DSm36wj23RK6MI50ANwKZKK1Tz0=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 21 Dec 2010 15:21:08 -0500
Message-ID: <AANLkTi=iVOumiTGzL3372JupX=+AiCohWEovSb_+xNZU@mail.gmail.com>
Subject: compat-wireless for 2.6.37-rc6
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two tarballs are out based on 2.6.37-rc6, the vanilla release and the
release with pending-stable patches and a few cherry picked patches.

http://wireless.kernel.org/en/users/Download/stable
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc6-3.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc6-3-sn.tar.bz2

Build tested and loaded with ath9k on AR9280 against 2.6.31.

The list of pending stable patches:

mcgrof@tux ~/tmp/compat-wireless-2.6.37-rc6-3 $ ls -1 pending-stable
0001-cfg80211-pass-the-reg-hint-initiator-to-helpers.patch
0002-cfg80211-fix-allowing-country-IEs-for-WIPHY_FLAG_STR.patch
0003-cfg80211-fix-disabling-channels-based-on-hints.patch
0008-ath9k_hw-Fix-XPABIAS-level-configuration-for-AR9003.patch
0009-ath9k-Fix-bug-in-delimiter-padding-computation.patch
0010-p54usb-add-5-more-USBIDs.patch
0012-ath9k-fix-assumptions-for-idle-calls-on-suspend-resu.patch
0013-ath-Missed-to-clear-key4-of-micentry.patch
0014-p54usb-New-USB-ID-for-Gemtek-WUBI-100GW.patch

The list of pending-stable patches which required a backport:

mcgrof@tux ~/tmp/compat-wireless-2.6.37-rc6-3 $ ls -1 pending-stable/backports/
0001-ath9k-simplify-hw-reset-locking.patch
0002-ath9k-move-the-PCU-lock-to-the-sc-structure.patch
0003-ath9k-content-DMA-start-stop-through-the-PCU-lock.patch
0004-ath9k-Fix-power-save-count-imbalance-on-ath_radio_en.patch
0005-ath9k_hw-fix-potential-spurious-tx-error-bit-interpr.patch

There are only two cherry picked patches now as the ath3k/btusb patch
went upstream:

mcgrof@tux ~/tmp/compat-wireless-2.6.37-rc6-3 $ ls -1 linux-next-cherry-picks/
01-ath9k-OTP.patch
04-ath9k_hw-fix-A-MPDU-key-search-issues-on-AR9003.patch

  Luis
