Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1AGSl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:41:57 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:54627 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1AGSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:41:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [RFC v3 0/5] hid-multitouch: a first step towards multitouch unification 
Date: Fri,  7 Jan 2011 19:42:37 +0100
Message-Id: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the v3.

all changes are coming from the mails with Henrik:

- restricted to new drivers only
- delete mt_buffer struct
- replace/adapt prev_valid in favor of seen_in_this_frame
- integrated fuzz
- introduce MT_QUIRKS
- other small fixes

Cheers,
Benjamin

