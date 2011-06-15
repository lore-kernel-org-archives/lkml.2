Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1FOTXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:23:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38672 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1FOTXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:23:16 -0400
Date: Wed, 15 Jun 2011 16:23:38 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: pull request: bluetooth-2.6 2011-06-15
Message-ID: <20110615192338.GC23248@joana>
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

Three regressions fix intended for 3.0. Two of them fix a change made in our
HCI security process for 3.0. The third one fixes an issue with non-SSP devices.
All of them are critical fixes. They should be in 3.0. Please pull! Thanks.

	Gustavo


The following changes since commit d6124baf8a098aacdbb85ff5b171da68dad6930e:

  Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-2.6 (2011-06-10 15:05:34 -0400)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Ilia Kolomisnky (1):
      Bluetooth: Fix L2CAP connection establishment

Johan Hedberg (1):
      Bluetooth: Fix accepting connect requests for defer_setup

Luiz Augusto von Dentz (1):
      Bluetooth: Fix L2CAP security check

 net/bluetooth/hci_conn.c   |    6 +++---
 net/bluetooth/l2cap_core.c |   21 +++++++++++++++------
 2 files changed, 18 insertions(+), 9 deletions(-)

