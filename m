Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2HNOG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:06:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35376 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2HNOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:06:24 -0400
Message-Id: <20120814140342.354405844@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Aug 2012 18:03:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: [patch 0/8] procfs fdinfo providers updated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

in this series I tried to address concerns on code duplication
at seq_fdinfo_open and proc_fd_link, thus fdinfo_open_helper()
is used in both routines. Also series updated to be appliable
on top of v3.6-rc1.

Please review, comments are highly appreciated.

	Cyrill
