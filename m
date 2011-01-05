Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1AEReh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:34:37 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:38904 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1AERef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:34:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [RFC v2 0/10] hid-multitouch: a first step towards multitouch unification 
Date: Wed,  5 Jan 2011 18:27:38 +0100
Message-Id: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

these patches is the set for the unified driver hid-multitouch.
I'm putting the flag RFC as I'm still waiting some testers feedback on some devices. But I don't think they will change a lot.

This would be great if this stuff could go into 2.6.38, if it's not too late.

These patches applies on top of Dmitry's next branch.

Cheers,
Benjamin

--

 drivers/hid/Kconfig          |   30 +--
 drivers/hid/Makefile         |    5 +-
 drivers/hid/hid-cando.c      |  274 ----------------------
 drivers/hid/hid-core.c       |    6 +-
 drivers/hid/hid-ids.h        |    7 +
 drivers/hid/hid-input.c      |   10 +-
 drivers/hid/hid-mosart.c     |  275 ----------------------
 drivers/hid/hid-multitouch.c |  526 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-quanta.c     |  261 ---------------------
 drivers/hid/hid-stantum.c    |  286 -----------------------
 include/linux/hid.h          |    6 +-
 11 files changed, 559 insertions(+), 1127 deletions(-)


