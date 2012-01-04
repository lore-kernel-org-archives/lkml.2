Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2ADPEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:04:00 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:35902 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab2ADPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:03:48 -0500
From: Daniel Wagner <wagi@monom.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 0/3] auth & enrypt cleanup attempt
Date: Wed,  4 Jan 2012 15:54:08 +0100
Message-Id: <1325688851-14920-1-git-send-email-wagi@monom.org>
X-Mailer: git-send-email 1.7.8.2.302.g17b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Hi,

Luiz and I had a discussion on IRC and he suggested
that it might make sense to remove duplicated code around
auth & enrypt in hci_event.c. I found it hard to 
really simply the code there. There are a lot of side
conditions.

Maybe using hci_conn_auth() makes sense since it will
also ask to encrypt the connection. 

cheers,
daniel

Daniel Wagner (3):
  Bluetooth: Make hci_conn_auth/encrypt public functions
  Bluetooth: Use hci_conn_auth() instead of open coded version
  Bluetooth: Use hci_conn_encrypt() instead of open coded version

 include/net/bluetooth/hci_core.h |    2 ++
 net/bluetooth/hci_conn.c         |    4 ++--
 net/bluetooth/hci_event.c        |   24 ++++--------------------
 3 files changed, 8 insertions(+), 22 deletions(-)

-- 
1.7.8.2.302.g17b4

