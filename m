Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab1EEAOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 20:14:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63422 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab1EEAOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 20:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=silNZDVBxNZcBaqSbIxk37NlUUxHMSL6aynw6i2qyZThY6YZy5ZVnxUdb+6j419COO
         0A9VVC/7RN19zz96BfM2vBYOUsIqw5EbZJZ8WMPxlVPRotiaWgCU0tNPCrjkoW6u/71/
         oew1XjGU84hiMUf7j7/1/X79lW3DZQLeRxm4g=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 May 2011 17:14:25 -0700
Message-ID: <BANLkTiktcsMYg=Pzi9nr0PC-w8WT_YTRwA@mail.gmail.com>
Subject: compat-wireless based on 2.6.39-rc6
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we close up on the regression fixing for 2.6.39 series I've prepped
up a new "-sp" compat-wireless release [1] based on 2.6.39-rc6. It has
one pending-stable fix:

0001-iwlwifi-fix-bugs-in-change_interface.patch

And one linux-next-pending patch:

0001-ath9k_hw-fix-power-for-the-HT40-duplicate-frames.patch

There is also a vanilla release without these two patches, but who
would want that? :) For more boring details you can check the
ChangeLog [3].

compat-wireless code metrics

    832608 - Total upstream lines of code being pulled
      2215 - backport code changes
      1922 - backport code additions
       293 - backport code deletions
      7534 - backport from compat module
      9749 - total backport code
    1.1709 - % of code consists of backport work
        14 - Code changes brought in from pending-stable
        11 - Code additions brought in from pending-stable
         3 - Code deletions brought in from pending-stable
    0.0017 - % of code being cherry picked from pending-stable
        13 - Code changes posted but not yet merged
        11 - Code additions posted but not yet merged
         2 - Code deletions posted but not yet merged
    0.0016 - % of code not yet merged

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.39-rc6
compat-wireless release: compat-wireless-v2.6.39-rc6-1-sp

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-rc6-1-sp.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/compat-wireless-2.6.39-rc6-1.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/ChangeLog-2.6.39-wireless

  Luis
