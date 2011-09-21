Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1IUPFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:05:15 -0400
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:53513 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1IUPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:04:47 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] autodetection of multitouch devices 
Date: Wed, 21 Sep 2011 16:56:53 +0200
Message-Id: <1316617015-11648-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

These two patches finally enable the kernel to handle multitouch devices correctly.
If a device presents in its report descriptors the usage Contact ID, then it is considered as
a multitouch device and handled by hid-multitouch.

Cheers,
Benjamin

