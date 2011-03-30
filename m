Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1C3Vvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:51:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36513 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab1C3Vvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=oIEU+xh/p1BL759Tdflvh5j6DaqmpgAX6qjrek3Y3NrtfHR5SfYdRkqtlav41k+pzN
         GycOx63YmbPRNG6I6IYGAeOMuK8+RBA6bjigZoeRhUBqREyK5OGCv0P1EZ4QQ15DDSKS
         2IDO95Ou3N0hSSAGtB8g4eSxYuIMojTwyfS10=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 30 Mar 2011 14:51:16 -0700
Message-ID: <AANLkTinPP8RuW+HgRWsppA3mSn6-2vE1z5UYUg=KKGia@mail.gmail.com>
Subject: compat-wireless-2.6.39-rc1 is out
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vanilla release:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-rc1-3.tar.bz2

Extra pending-stable patches applied:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-rc1-3-s.tar.bz2

At this point I'd highly recommend the -s release given that it has
these three important patches which have not trickled down to Linus
yet:

mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.39.y)$ ls -1
pending-stable/
0001-mac80211-fix-a-crash-in-minstrel_ht-in-HT-mode-with-.patch
0002-ath9k-fix-a-chip-wakeup-related-crash-in-ath9k_start.patch
0003-iwlegacy-fix-bugs-in-change_interface.patch

Compile tested the entire thing on 2.6.35, load tested iwlagn. For more details:

http://wireless.kernel.org/en/users/Download/stable

  Luis
