Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1CRN1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:27:44 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:39037 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1CRN1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:27:38 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Migrations to hid-multitouch, round 3 
Date: Fri, 18 Mar 2011 14:27:51 +0100
Message-Id: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This is the third version for this patch series.

Since last time, I mainly modified the patch #1 to adapt
Henrik's comments. I also added #4 as the code path was confusing.

Cheers,
Benjamin

