Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1BID0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:26:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab1BID03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:26:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XCSIWYwVOrlc7cITLng/bn1IQgevTOsm28kMMUI74A1K40GOapm2MloSfBVIQQLXG2
         0tC1bFfHlyXyIzv/N+Riv/IXzhL42lplDXVPuz9rb1uGjD5NtXg7GNOrU42K4FCAbhc6
         BuVGHvF5qDtt+dWJo8yqNQ9KoqDeO4uHC3af8=
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ryan@bluewatersys.com, akpm@linux-foundation.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Wed,  9 Feb 2011 16:25:58 +1300
Message-Id: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth submission of a yaffs2 patchset.

I would like to thank everyone that has given comments so far, with
particular mention of Ryan Mallon at Bluewater Systems.

I would like to thank CELF (now part of Linux Foundation) and Google
for sponsoring the effort to get yaffs2 mainlined.

This code is patched from 7ad3c1635865d2e214eaef02ec53f0eb3956daa6
at git://www.aleph1.co.uk/yaffs2.

This patch set takes onboard almost all of Ryan's comments to make the
code paths cleaner.

This code ran various tests for the whole night with no problems seen.

Comments/feedback welcome, but I'm hopefully getting pretty close to
acceptance :-).

-- Charles
