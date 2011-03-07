Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1CGTaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:30:18 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49361 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1CGTaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=eQM4LqNf9BqnVrkzyfGmj27FdF8WW0T9qiXhYXNPEFi8eMIHQVwl3j9IK40hI1TJ4R
         Q/gxKgrvOXrktiIjZVi1q7S4HTCIcVS0hD6NhgRwkiSuU0PfVbDjgOIaAMEXTO8hIWq7
         aUZXRMpJrhLbSunmJVCQFkrEjsEm/Jb/Jb/zU=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 7 Mar 2011 20:30:14 +0100
Message-ID: <AANLkTik68fcAgBBFYxW_PRuWoF1LS87SPLnihG2ASZN=@mail.gmail.com>
Subject: Re: linux-next: Tree for March 7 (BROKEN iwlwifi)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next (next-20110307) has still this build-failure with iwlwifi
which was already reported and a fix was offered by Stanislaw.
(JFYI: Build-host is a Debian/sid i386 system.)

/home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-rx.c:
In function 'iwl_rx_card_state_notif':
/home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-rx.c:778:3:
error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
/home/sd/src/linux-2.6/linux-2.6.38-rc7/debian/build/source_i386_none/drivers/net/wireless/iwlwifi/iwl-rx.c:778:3:
note: each undeclared identifier is reported only once for each
function it appears in
make[8]: *** [drivers/net/wireless/iwlwifi/iwl-rx.o] Error 1
make[8]: *** Waiting for unfinished jobs....

- Sedat -

[1] iwlwifi-fix-iwl-rx.c-compilation.patch
https://patchwork.kernel.org/patch/614961
