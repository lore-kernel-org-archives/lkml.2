Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2EDMyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:54:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53175 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2EDMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:54:04 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/5] Bug fix and win8 for hid-multitouch 
Date: Fri,  4 May 2012 14:53:45 +0200
Message-Id: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

The first patch fixes the bug I discovered lately. This bug was related to the out
of bound bitfield test, so it concerns every known devices. Ideally, it should go
to upstream-fixes, but this would requires additional adaptations.
Jiri, How do you want to proceed?

The last 4 patches are the beginning of the support of Win8 devices. It's only the
beginning as the specification is much more precise than the Win7, and we will need
to do more tuning in the future. However, Win8 devices are retro-compatible with
Win7, so they will work out of the box though.

Cheers,
Benjamin

