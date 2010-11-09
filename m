Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0KIW4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:56:25 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0KIW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=R5TYcU5uWlolHrv9IhEqG682BT7Few2YIm+331OQD2sIWa0VnET22SYdlxquonG84F
         mdnDitDWbQKIckpaNxuV5uzE4iscpBdJ2iMtIFDwcq0xAa0CrwWKjZ28u6zj6G030UDB
         jrvtcQx7lfeAKfWULBgC5ggpg2aWGaKYctqp0=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Nov 2010 14:56:02 -0800
Message-ID: <AANLkTimz=0MknJnivvEb_Uq4fjDWFDUN5ug=kOo+eocd@mail.gmail.com>
Subject: Compat-wireless for 2.6.37-rc1 - 802.11, Bluetooth and Ethernet backported
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus released 2.6.37-rc1 a couple of weeks ago and we now have our
first vanilla release for the same kernel. This is a stable  [1]
compat-wireless-2.6.36-rc7-1 [2], this release has no extra patches
applied on top and at this point I am a bit lazy to go ahead and suck
these in so please note you'll likely end up with a lot of stable
patches missing but I will hope that in the next linux-next.git these
get sucked in and I can simply use ./scripts/admin-updates.sh -s to
suck them in for the rc2 release.

Please report any issues ASAP but be-aware there are a few stable
patches missing still. I'd trust the compat-wireless-2.6.36-5-spn
right now more if you are looking for something really stable, but I
do expect this release to stabilize after a couple of RCs. For details
on changes you can refer to the now very highly detailed
ChangeLog-2.6.37-rc1-wireless [3] which includes the changes for
compat.git, compat-wireless.git and the Linux kernel for the
backported subsystems.

Origin remote URL:
git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
This is a stable compat-wireless release

compat-wireless code metrics

    739355 - Total upstream lines of code being pulled
      2163 - backport code changes
      1909 - backport code additions
       254 - backport code deletions
      6324 - backport from compat module
      8487 - total backport code
    1.1479 - % of code consists of backport work

Base tree: linux-2.6-allstable.git
Base tree version: v2.6.37-rc1
compat-wireless release: compat-wireless-v2.6.37-rc1-1

Cleaning up the release ...
Creating compat-wireless-2.6.37-rc1-1.tar.bz2 ...

Compat-wireles release: compat-wireless-2.6.37-rc1-1
Size: 3.7M	compat-wireless-2.6.37-rc1-1.tar.bz2
sha1sum: 60b1c6e9d421f039e22b62901de816a46931a603
compat-wireless-2.6.37-rc1-1.tar.bz2

  Luis

[1] http://wireless.kernel.org/en/users/Download/stable
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-1.tar.bz2
[3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/ChangeLog-2.6.37-wireless
