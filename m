Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314Ab2HPQhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:37:42 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45220 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030198Ab2HPQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:37:38 -0400
Message-Id: <20120816163408.625246843@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Aug 2012 20:34:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: [patch 0/7] procfs, fdinfo reworked, attempts N-th
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here is a bit reworked series

 - all exportfs junk is dropped out of code
 - fdinfo for seq-files uses embedded seq_file entry
 - dnotify is not yet addressed (but fdinfo for fsnotify can be easily
   extended in future)

Al, may I ask you to take a look on final fdinfo seq-file approach?
Pavel, could you please check the fdnotify patch, will current amount
of data be enough for us?

Any complains are welcome.

	Cyrill
