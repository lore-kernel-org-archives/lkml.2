Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424436Ab2LGU4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:56:46 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41124 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424380Ab2LGU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:56:45 -0500
Message-Id: <20121207205259.394558474@openvz.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Dec 2012 00:52:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/2] An update to fanotify fdinfo output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Andrew, here is an update for fanotify fdinfo output.
I also update documentation to fit the current state of
the output format. This should be the last bits we need
for fdinfo. As always any comments are highly appreciated.

	Cyrill
