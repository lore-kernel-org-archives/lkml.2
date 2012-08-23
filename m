Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961Ab2HWKrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:47:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36681 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933811Ab2HWKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:47:30 -0400
Message-Id: <20120823104323.040550004@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 14:43:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: [patch 0/9] extended fdinfo via procfs series, v7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here is updated version of the fdinfo via procfs series,
the changes from previous one are the following

 - fhandle is carried inside inotify mark but this feature
   is CONFIG dependent to not bloat the kernel for users
   who don't need it

 - a small fix in exportfs code to prevent nil dereference

the comments would be appreciated.
