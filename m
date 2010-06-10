Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0FJLAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:00:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38924 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FJLAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:00:37 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/1] VFS: introduce s_dirty accessors
Date: Thu, 10 Jun 2010 13:56:32 +0300
Message-Id: <1276167393-31492-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
X-OriginalArrivalTime: 10 Jun 2010 11:00:09.0569 (UTC) FILETIME=[17AA9510:01CB088C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

would it be possible to add the following patch to your tree. I'm trying
to lessen amount of useless wake-ups in the kernel, and the 'sync_supers'
thread if one of those kernel threads which wakes up every 5 seconds to
(mostly) do nothing.

This is still work in progress, but putting the below patch to your tree
would make life easier at the next merge window. This patch just adds 3
accessor functions, but no one will use them so fare, so it must be
harmless. This was suggested by Ted and supported by Al:
http://lkml.org/lkml/2010/6/9/216

Artem.
