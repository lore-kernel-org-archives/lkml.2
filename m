Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1K2MNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:13:36 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:45727 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1K2MNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:13:34 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] last merge in hid-multitouch 
Date: Tue, 29 Nov 2011 13:13:09 +0100
Message-Id: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Here are some multitouch updates.
The first one is the last merge to handle all win7 compliant multitouch
devices in hid-multitouch (finally, we've got it!).
The others are the migration to input_register to allocate items before
the input is ready, and another VID/PID.

Cheers,
Benjamin

