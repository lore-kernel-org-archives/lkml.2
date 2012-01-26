Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2AZVwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:52:09 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53263 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab2AZVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:52:07 -0500
MIME-Version: 1.0
Date: Thu, 26 Jan 2012 22:52:05 +0100
Message-ID: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
Subject: /sys/class/tty/tty0/active?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

systemd goes nuts on UML.
While hunting down all issues I found out that systemd wants to read from
/sys/class/tty/tty0/active.

On UML this directory does not have this "active" file.
[1] indicates that it has something to do with /dev/tty0.
Of course, UML has a /dev/tty0, it's the default console.

But where comes "active" from?
Is there any black magic hidden register API to get this file? ;-)

[1]
http://lists.freedesktop.org/archives/systemd-devel/2011-December/004096.html

-- 
Thanks,
//richard
