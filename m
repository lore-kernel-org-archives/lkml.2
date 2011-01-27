Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1A0Kf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:35:57 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:33424 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1A0Kfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:35:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Ping Cheng <pingc@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] Add EVIOC mechanism to extract the MT slot state 
Date: Thu, 27 Jan 2011 11:35:45 +0100
Message-Id: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This patchset is a rework of Henrik's original work.
Henrik, I kept your signed-off-by, please tell me if it's ok with you.
I just changed the method call (and signature) for it to be compliant with the new EVIOC handling.

I'm not very happy with it (for instance, there is a call of an mt stuff in generic input), but it's a start.

Cheers,
Benjamin



