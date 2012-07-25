Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2GYJ5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:57:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51186 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab2GYJzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:55:41 -0400
Message-Id: <20120725094718.089879534@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 25 Jul 2012 13:47:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: [patch 0/7] procfs fdinfo extension, new round
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here is a bit updated version of patches
for procfs fdinfo outpu extension (which we
need to be able to restore eventfd/epoll/inotify
files).

I tried to addess Matthew's and Pavel's comments
(well, I rather didn't inject new member into
 file_operations structure and comment in change
 log will explain why).

Please review, and thanks a lot for previous feedback!
