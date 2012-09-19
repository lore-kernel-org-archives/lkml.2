Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2ISALz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:11:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52946 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2ISALw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:11:52 -0400
Date: Tue, 18 Sep 2012 21:11:43 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2012-09-18
Message-ID: <20120919001143.GD24689@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Here goes probably my last update to 3.6. It includes the two patches you
were ok last week(from Andrzej Kaczmarek), those are critical ones, and two
other fixes one for a system crash and the other for a missing lockdep
annotation.

Please pull or let me know of any problems!

	Gustavo

---
The following changes since commit e020a83d0942a5aceac35986500c9834efc8707d:

  brcmfmac: Fix big endian host configuration data. (2012-09-12 14:15:31 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master

for you to fetch changes up to 78c04c0bf52360dc2f7185e99c8e9aa05d73ae5a:

  Bluetooth: Fix not removing power_off delayed work (2012-09-18 20:13:02 -0300)

----------------------------------------------------------------
Andrei Emeltchenko (1):
      Bluetooth: Fix freeing uninitialized delayed works

Andrzej Kaczmarek (2):
      Bluetooth: mgmt: Fix enabling SSP while powered off
      Bluetooth: mgmt: Fix enabling LE while powered off

Vinicius Costa Gomes (1):
      Bluetooth: Fix not removing power_off delayed work

 net/bluetooth/hci_core.c   |  2 ++
 net/bluetooth/l2cap_core.c |  2 +-
 net/bluetooth/mgmt.c       | 16 ++++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

