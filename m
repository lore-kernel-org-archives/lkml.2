Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1BNQBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:01:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53313 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab1BNQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=dpjbOyxlYjTQYUIbPVdqsUyxNk0ZRre9KjhHnaV+OOqXNiuddavEiS/Y2tpFO1a49H
         mYtXk3rQJZfs+9l8GW4VbwjAuwP+y39Uxx2mBJTCFgiTm9NbXfp+9C1PCNV2n2G4SNMS
         9/1bZmK2NEJvWnaayQQ5spIsyUUSDr3ztDxdE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 14 Feb 2011 17:01:07 +0100
Message-ID: <AANLkTi=G5pLNqLw1RGNauD+9D76uJfEgNXuef1Po6km7@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: DRI <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ As I am not subscribed to both MLs and lazy to pick up all involved people ]

Hi Chris,

The original patch had also this part (see the revert in [1]):
...
+#include <linux/security.h>
...

Your new patch in [2] is missing it or is it not required?

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f00eaeea7a42b5ea327e9ce8839cb0b53d3bdb4e
[2] https://patchwork.kernel.org/patch/555501/
