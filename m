Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab1ESMSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:18:37 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:57157 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab1ESMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:18:35 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Support for multiple devices 
Date: Thu, 19 May 2011 14:18:12 +0200
Message-Id: <1305807498-8785-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

here is a bunch of new devices for 2.6.40.

I am still getting some reports for new multitouch devices.
Usually, I ask people to send the logs of the device to be able
to finely tune the kernel processing of the events.
As of today, I've got 5 devices that needs to be tested with
the fine tuning or that I missed the logs (ActionStar, CVTouch,
GoodTouch, Touch International and Unitec panels).
Instead of waiting eternally for the feedback, I thought I
should send them for inclusion now, and we will eventually
reduce the kernel processing for those devices later.
All these devices show that they are Win7 compliant from
their report descriptors (and logs for some of them), so it
should be safe.

Finally, I saw that the class for Stantum devices was redundant
with the one included by Ilitek, so I moved Stantum
devices to the generic one.

Cheers,
Benjamin

