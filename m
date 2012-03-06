Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2CFQ50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:57:26 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab2CFQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:57:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of benjamin.tissoires@gmail.com designates 10.180.92.229 as permitted sender) smtp.mail=benjamin.tissoires@gmail.com; dkim=pass header.i=benjamin.tissoires@gmail.com
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/5] Autohandling of multitouch devices through hid-multitouch
Date: Tue,  6 Mar 2012 17:57:01 +0100
Message-Id: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

In this patch series, I introduce 1 trivial patch plus 4 patches that need review I think:
- the first is trivial (I missed it this morning, sorry)
- the second fixes a problem detected with LG panels. The detection of the end of the
  report was not accurate, and needed to be rewritten. I'm worried about it because I got
  warnings under Ubuntu for this patch (-Warray-bounds) whereas I don't get any warnings
  under Fedora.
- the third should not be a problem as it relies on the presence of the QUIRK_MULTITOUCH
  and will impact only unknown devices.
- the fourth worries me more. I introduce changes in hid_device, and I'd like to have your opinion.
- Then, the last one allows us to be compliant with Microsoft's description for Win 7 devices.

Cheers,
Benjamin

PS: Thanks Henrik and Jiri for the series of this morning.


