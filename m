Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2HOJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:24:17 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47893 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756Ab2HOJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:24:13 -0400
Message-Id: <20120815092116.700948346@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Aug 2012 13:21:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: [patch 0/8] procfs, fdinfo updated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here is an updated series. As being discussed with Al
the fdinfo helper provided via file_operations. Also
I've dropped CONFIG_CHECKPOINT_RESTORE wrap from inside
of particular subsystems, thus this new feature will be
available by default. I've tested the whole series but
additional review would be appreciated.

Please tell me wht you think.

	Cyrill
