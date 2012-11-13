Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2KMU3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:29:22 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45258 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab2KMU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:27:46 -0500
Message-Id: <20121113202023.748833257@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Nov 2012 00:20:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com
Subject: [patch 0/7]  Providing additional information in fdinfo sufficient for c/r, v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, here is an updated series for fdinfo. I've shrunk the buffer
attached to inotify mark and updated the changelog for it (still wonder
if there some document in Documentation/ which should be updated as well),
the signalfd was fixed too. Please review, I tried to address all complains
I've got so far, ping me if I missed something please.

	Cyrill
