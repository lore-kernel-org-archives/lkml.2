Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1BHBLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:11:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40247 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1BHBLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:11:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=FtrLIJaC0XmTgFSYc6QftWX4fE84UowLKli6BCQjxRv1/HrUZAR58gZ7DPUAXmPw9r
         o4y4E8e5jxiEss6Ihy8vK9CnESGxgH0lmnszoDJ/G4Ax8F3o7A6Sk9/osJ5jlLa52jAm
         0Q8rwhhgOfJpH6axNQtNV6cJWEMaA12+pPaP8=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 7 Feb 2011 17:10:49 -0800
Message-ID: <AANLkTineqSLDLg84Ah7Djd1R=K-xTfQDUd==K+eaJFES@mail.gmail.com>
Subject: compat-wireless for 2.6.38-rc3 - third release
To: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated compat-wireless for 2.6.38-rc3, this is the third update, it
should now include the proper compat.git branch and also adds some new
patches from Hauke to minimize deltas and fix compilation. While at it
I took the time to suck in new pending-stable patches for an "-s"
release, I haven't cherry picked any patches yet as I cannot think of
anything immediately important, if you do send me a patch.

Code metrics for the vanilla release:

    782535 - Total upstream lines of code being pulled
      2108 - backport code changes
      1847 - backport code additions
       261 - backport code deletions
      7292 - backport from compat module
      9400 - total backport code
    1.2012 - % of code consists of backport work

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.38-rc3
compat-wireless release: compat-wireless-v2.6.38-rc3-3

Code metrics for the "-s" release:

    782535 - Total upstream lines of code being pulled
      2108 - backport code changes
      1847 - backport code additions
       261 - backport code deletions
      7292 - backport from compat module
      9400 - total backport code
    1.2012 - % of code consists of backport work
       115 - Code changes brought in from pending-stable
        57 - Code additions brought in from pending-stable
        58 - Code deletions brought in from pending-stable
    0.0147 - % of code being cherry picked from pending-stable

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.38-rc3
compat-wireless release: compat-wireless-v2.6.38-rc3-3-s

Relevant URLs:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/compat-wireless-2.6.38-rc3-3.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/compat-wireless-2.6.38-rc3-3-s.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.38/ChangeLog-2.6.38-wireless
http://wireless.kernel.org/en/users/Download/stable

  Luis
