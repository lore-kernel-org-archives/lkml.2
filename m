Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0LJWnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:43:55 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:44844 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0LJWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:43:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=skoHPKsStEa87oZoyQmf+gZ4HQRp6vITGupFrp2KFFzWV0Nu1aAsqgSdzZxFlArd2F
         /B2SP5zcZSLICfUwJFjulmLh0nItGhRfH/qP9jBaC9pwNTax9hvvzLHKiCoerLfp2zo1
         CFue67j1N3L3IHMXCRhRbjb8YEvfpg42c51v8=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Dec 2010 14:43:32 -0800
Message-ID: <AANLkTikNgTObTt7nfxymn+3_B1+xDOB9X1wE2bgJRnA9@mail.gmail.com>
Subject: compat-wireless-2.6.37-rc5-3-sn.tar.bz2 release
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've sucked in all pending-stable patches from linux-next.git into a
compat-wireless release based on upstream 2.6.37-rc5. A few patches
required a manual backport. On top of that I've sucked in a few cherry
picked patches:

mcgrof@tux ~/tmp/compat-wireless-2.6.37-rc5-3-sn $ ls -1
linux-next-cherry-picks/
01-ath9k-OTP.patch
02-ath9k-no-aggr-VO.patch
03-mac80211-no-aggr-VO.patch
04-ath9k_hw-fix-A-MPDU-key-search-issues-on-AR9003.patch
05-Bluetooth-Add-new-PID-for-Atheros-3011.patch
README

If you have a need for any other other patches please feel free to
send over. This is closing in on the first formal release for a
compat-wireless-2.6.37, please give this a good try and report any
issues. These release are aimed at being very stable given that we are
sucking all pending stable patches, and cherry picking a few patches
we choose to support. Particularly you will see we have added the OTP
stuff for AR9003. If you happen to have an AR9003 card your card may
have either an EEPROM or OTP, and this release will support both
cards. Both types of cards will be supported upstream as of 2.6.38.

Greg, if you have an issue with applying a stable patch on 2.6.37 you
can find the respective backport in the pending-stable/backports/
directory of the compat-wireless.git linux-2.6.37.y branch. I can
refer you to this once gitweb has it up on the link:

http://wireless.kernel.org/en/developers/stable-pending

I should note, I have backported *all* patches that failed to apply,
but the last one, the orinoco one is not applicable to stable as it
failed for other reasons (compat-wireless patches/ dir)

The juicy link:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc5-3-sn.tar.bz2

  Luis
