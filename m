Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1FUNCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:02:00 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:48719 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FUNB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:01:59 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] hid-multitouch: corrections for 3.0-rc4 
Date: Tue, 21 Jun 2011 15:01:52 +0200
Message-Id: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

This is a set of patches for 3.0:
- the first (ensure slots are initialized) corrects a bug with some Ilitek panels not working properly
- the second (correct VID for Stantum) corrects a mistake in the merge of hid-stantum
- the last one is a new PID for Lumio products (not a bug, but as new PID are accepted in the stable branch, I thought we can make it there)

Cheers,
Benjamin

