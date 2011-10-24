Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1JXVC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:02:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36890 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1JXVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:02:57 -0400
Message-Id: <20111024205657.807512807@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 Oct 2011 00:56:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Nathan Lynch <ntl@pobox.com>, Andrew Morton <akpm@linux-foundation.org>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [patch 0/2] fs, proc map_files new entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fresh linux is out, so here the two patches were flowing around
for pretty long time. Now they are well tested and reviewed. While
c/r code is still under heavy development the /proc/map_files might
be useful for other purposes as well, so please give them a chance.

Cyrill
