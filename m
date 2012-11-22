Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2KVVWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:22:46 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54222 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2KVVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:22:39 -0500
Message-Id: <20121122211522.075455799@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Nov 2012 01:15:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org
Subject: [patch -mm 0/4] Fixes for fdinfo output and docs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, here are few nit-fixes for /proc/<pid>/fdinfo/<fd> handlers and
I tried to write some documentation about the format used in output. I guess
Documentation/filesystems/proc.txt is the best place for it since the
information is rendered via procfs inteface.

Guys, I would really appreciate to feedback on documentation changes and
complains are quite welcome here.

(As to one of previous feedback

 | btw, Documentation/sysctl/fs.txt is missing documentation for
 | max_user_instances and max_queued_events.  Perhaps you can fix that
 | when providing the documentation changes for your patch.

 I remember about it and will cook patch soon).

	Cyrill
