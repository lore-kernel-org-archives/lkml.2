Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0GEMTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:19:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20745 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767Ab0GEMTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:19:01 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 0/9] kill unnecessary SB sync wake-ups + cleanups
Date: Mon,  5 Jul 2010 15:14:58 +0300
Message-Id: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
X-OriginalArrivalTime: 05 Jul 2010 12:18:42.0265 (UTC) FILETIME=[34FAAC90:01CB1C3C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is v6 of my SB sync wakups killing patches, v5 may be found:
http://marc.info/?l=linux-fsdevel&m=127583599911620&w=2

This is more of a reminder re-send, I did not get any feed-back for
v5. Not much changes since v5:

1. Drop patches which fix race conditions for s_dirty changes WRT actual
   write-back - these things are independent and I am planning to go through
   that separately.
2. Add "Acked-by" to the btrfs patch.
3. Fold all per-fs patches which introduce SB accessors into one big patch.

Artem.
