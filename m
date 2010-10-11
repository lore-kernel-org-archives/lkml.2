Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0JKQSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:18:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39748 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0JKQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ucSexifPOZ8sl3AN1Xk3VRl2Nt365p4WYGLO07UvstGMeyq6F72FLVHxtWRkUFklQU
         hr6PYryzrzRah1jGAYsWmMm9Ua/V2NiHgyjNj0n1QvuwfmXqlSp+N1QLkpaUkEBx+n6m
         Bee/8PsCK8VFI6Aa9Vw0cDc3UCUw8p4BLAG4E=
Date: Mon, 11 Oct 2010 09:18:23 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.36-rc7
Message-ID: <20101011161822.GB5149@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive a small fixup to Wacom tablet driver.

Changelog:
---------

Aristeu Rozanski (1):
      Input: wacom - fix pressure in Cintiq 21UX2


Diffstat:
--------

 drivers/input/tablet/wacom_wac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

