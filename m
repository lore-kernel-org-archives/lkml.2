Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2JPJu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:50:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40990 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2JPJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:49:40 -0400
Message-Id: <20121016094622.337128953@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Oct 2012 13:46:22 +0400
From: gorcunov@openvz.org
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz
Subject: [patch 0/3] TTY flags fetching
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, I've updated the series on top of current tty-next Greg's tree.
The series introduces new ioctl codes TIOCGPKT, TIOCGPTLCK, TIOCGEXCL to
fetch pty's packet mode and locking state, and exclusive mode of it, which
we really need to know when we do checkpoint-restore transition.

Please review, thanks!
