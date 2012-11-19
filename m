Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2KSAd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:33:26 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42379 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:33:25 -0500
MIME-Version: 1.0
Date: Mon, 19 Nov 2012 08:33:25 +0800
Message-ID: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
Subject: Recent kernel "mount" slow
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the recent kernel is slower mounting hard disk than older
kernels. I've not bisect down to exact when this happen as it might
already been reported or solved. I'm on the latest commit, but it
doesn't seems to be fixed yet.

commit 3587b1b097d70c2eb9fee95ea7995d13c05f66e5
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Sun Nov 18 19:19:00 2012 +0000

    fanotify: fix FAN_Q_OVERFLOW case of fanotify_read()


Thanks,
Jeff
