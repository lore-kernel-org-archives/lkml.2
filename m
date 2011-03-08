Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1CHQdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:33:41 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:49740 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1CHQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:33:40 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Migrations to hid-multitouch
Date: Tue,  8 Mar 2011 17:32:55 +0100
Message-Id: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

As mentioned on the list, I think that the following drivers can safely be moved to hid-multitouch:
3M, Stantum and Cando.

This let Quanta and Mosart in the queue.

In addition, I also added the auto-detection of the maximum contact number a device can handle based on the report descriptors.

Cheers,
Benjamin


