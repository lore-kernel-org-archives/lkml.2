Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1HGVFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:05:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40050 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab1HGVFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:05:32 -0400
Message-Id: <20110807210112.245578619@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 08 Aug 2011 01:01:12 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/4] C/R related patch series
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While checkpoint-restore implementation is still in progress
(and it's more biased to user-space c/r) some preparing patches
are simple enough to be released early (and there is a hope they
will be merged ;)

Thanks.
