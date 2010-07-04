Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0GDWEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 18:04:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49110 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0GDWEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 18:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ez9mX2SX7k1kvidZ3h6G2wq/72X0Is5UcRb1gW3T2+txeDqzem5wFm+dTcnk4HnPEC
         FfhJ+U/SwKynzLPhOcfbS03gCmZRVpHVYa1JYHJ7f9wFGO5OhO4VeJ/8Hnx6jMRUuhky
         GLKGTSqG8HoAVLD/TQuqtIWU9zEeHMCgGxQQ0=
MIME-Version: 1.0
Date: Sun, 4 Jul 2010 18:04:20 -0400
Message-ID: <AANLkTinof0k28rk4rMr66aubxcRL2rFa5ZEArj1lqD3o@mail.gmail.com>
Subject: 2.6.35-rc3-git8 - include/linux/fdtable.h:88 invoked 
	rcu_dereference_check() without protection!
From: Miles Lane <miles.lane@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 1619.938226] [ INFO: suspicious rcu_dereference_check() usage. ]
[ 1619.938230] ---------------------------------------------------
[ 1619.938235] include/linux/fdtable.h:88 invoked
rcu_dereference_check() without protection!
[ 1619.938239]
[ 1619.938240] other info that might help us debug this:
[ 1619.938242]
[ 1619.938245]
[ 1619.938246] rcu_scheduler_active = 1, debug_locks = 1
[ 1619.938250] no locks held by dbus-daemon/4254.
[ 1619.938253]
[ 1619.938254] stack backtrace:
[ 1619.938260] Pid: 4254, comm: dbus-daemon Not tainted 2.6.35-rc3-git8 #5
[ 1619.938264] Call Trace:
[ 1619.938277]  [<ffffffff8106756a>] lockdep_rcu_dereference+0x9d/0xa6
[ 1619.938286]  [<ffffffff810cae92>] fcheck_files+0xb1/0xca
[ 1619.938292]  [<ffffffff810caf03>] fget_light+0x35/0x96
[ 1619.938300]  [<ffffffff810d8d5e>] do_sys_poll+0x1ff/0x3e5
[ 1619.938307]  [<ffffffff810d8572>] ? __pollwait+0x0/0xc7
[ 1619.938314]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938320]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938327]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938333]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938340]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938346]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938353]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938359]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938365]  [<ffffffff810d8639>] ? pollwake+0x0/0x4f
[ 1619.938374]  [<ffffffff810d90d8>] sys_poll+0x50/0xba
[ 1619.938383]  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
