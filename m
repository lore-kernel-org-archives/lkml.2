Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0HGILF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:11:05 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50439 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0HGIK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:10:59 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] improve list_sort test
Date: Sat,  7 Aug 2010 11:10:39 +0300
Message-Id: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 07 Aug 2010 08:10:54.0135 (UTC) FILETIME=[0E83D470:01CB3608]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while hunting a non-existing bug in 'list_sort()', I've improved the
'list_sort_test()' function which tests the 'list_sort()' library call. Although
at the end I found a bug in my code, but not in 'list_sort()', I think my
clean-ups and improvements are worth merging because they make the test function
better.

Don, if you are ok with the patches, I'll send them to Andrew Morton.

Artem.
