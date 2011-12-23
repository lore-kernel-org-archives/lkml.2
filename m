Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab1LWVJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:09:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53355 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab1LWVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:09:50 -0500
Date: Fri, 23 Dec 2011 19:10:20 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2011-12-23
Message-ID: <20111223211020.GH5287@joana>
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

This commit was causing resume issues in a Thinkpad laptop, please pull it.
Can we make this for 3.2? Thanks.

	Gustavo

The following changes since commit 96f1f05af76b601ab21a7dc603ae0a1cea4efc3d:

  iwlwifi: update SCD BC table for all SCD queues (2011-12-19 14:20:39 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth master

Gustavo F. Padovan (1):
      Revert "Bluetooth: Increase HCI reset timeout in hci_dev_do_close"

 net/bluetooth/hci_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
