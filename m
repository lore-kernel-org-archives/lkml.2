Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2A0R7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:59:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58592 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2A0R7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:59:45 -0500
Message-Id: <20120127175342.273260614@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 21:53:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC c/r 0/4] [RFC c/r 0/@total@] A pile in c/r sake
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, please review, I hope I've addressed all concerns,
if not -- please poke me.

And I left /proc/pid/task/tid/children "as a file"
approach since I've got no strong objections.

	Cyrill
