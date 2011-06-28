Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1F1BZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:25:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11912 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab1F1BWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:22:37 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergiu Iordache <sergiu@chromium.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] char drivers: ramoops improvements
Date: Mon, 27 Jun 2011 18:21:50 -0700
Message-Id: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches improves ramoops by allowing it to be used only with
module parameters (without having to set a platform device externally),
adding a new parameter for the dump size in order to be able to save larger
logs and updating the platform data structure to allow setting all the
options through it.

Sergiu Iordache (3):
  char drivers: ramoops default platform device for module parameter
    use
  char drivers: ramoops dump_oops platform data
  char drivers: ramoops record_size module parameter

 drivers/char/ramoops.c  |   39 ++++++++++++++++++++++++++++++++-------
 include/linux/ramoops.h |    2 ++
 2 files changed, 34 insertions(+), 7 deletions(-)

-- 
1.7.3.1

