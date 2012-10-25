Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946059Ab2JYOLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:11:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50419 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab2JYOK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:10:59 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] Support for Win 8 digitizers 
Date: Thu, 25 Oct 2012 16:09:39 +0200
Message-Id: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

well, this is my first series as a Red Hat employee. I should be able to
communicate my email address soon (once I'm able to read it).

So, this is an update for supporting Win 8 multitouch devices in the kernel.
As I wanted to reliably forward the resolution, I noticed a bug in the
processing of the unit exponent in the hid core layer.
Thus the fixes for hid-core and hid-input.

The last patch removes the dependency for usbhid as now touchscreen may
be connected through i2c.

Cheers,
Benjamin


