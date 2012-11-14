Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422820Ab2KNPWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:22:52 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64683 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2KNPWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:22:45 -0500
Message-Id: <20121114151937.344922058@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Nov 2012 19:19:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk
Subject: [patch 0/7] Providing additional information in fdinfo sufficient for c/r, v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, here is updated series for fdinfo via procfs. The main
change is that we've dropped carrying fhandle with inotify mark
but provide it on demand. This is achieved by adding a small helper
into exportfs code. Please review, thanks a lot for all earlier
comments!

	Cyrill
