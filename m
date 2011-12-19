Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1LSNew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:34:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57109 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1LSNes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:34:48 -0500
Date: Mon, 19 Dec 2011 11:35:24 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2011-12-19
Message-ID: <20111219133524.GB2610@joana>
Mail-Followup-To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

3 fixes for 3.2! There one revert that was causing connection issues, a RFCOMM
fix to a potential kernel panic, and the last on L2CAP to a possible access to
uninitialized data due to broken remote devices.

Please pull, or let me know any problems.

	Gustavo

The following changes since commit 78feb35b8161acd95c33a703ed6ab6f554d29387:

  iwlwifi: allow to switch to HT40 if not associated (2011-12-14 13:56:55 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth master

Gustavo F. Padovan (1):
      Revert "Bluetooth: Revert: Fix L2CAP connection establishment"

Mat Martineau (2):
      Bluetooth: Prevent uninitialized data access in L2CAP configuration
      Bluetooth: Clear RFCOMM session timer when disconnecting last channel

 net/bluetooth/hci_conn.c    |    2 +-
 net/bluetooth/l2cap_core.c  |   12 +++++++++++-
 net/bluetooth/rfcomm/core.c |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

