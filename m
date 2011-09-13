Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1IMVYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:24:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41799 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab1IMVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:24:52 -0400
Message-Id: <20110913211359.674453213@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Sep 2011 01:13:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org
Cc: Kirill Shutemov <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [patch 0/2] symlinks for mapped files in proc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, since due to discussion on the patch "fs, proc: Introduce the
/proc/<pid>/map_files/ directory" it was found that better to split
it into two patches (in a sake of bisectability and non-intersection
in code touched) -- this series does it. Please review. I hope all
concerns are addressed this time. Complains are still welcome.

	Cyrill
