Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2AZWmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:42:04 -0500
Received: from smtp1.powertech.no ([195.159.0.145]:54058 "EHLO
	smtp1.powertech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2AZWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:42:00 -0500
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jan 2012 17:42:00 EST
Message-ID: <58311.79.160.186.248.1327615864.squirrel@www.nlc.no>
In-Reply-To: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
References: <CAFLxGvw85fWdsAodBn1Z0vFYZx0U+vYg6hgsBYbmfuyaFTgznA@mail.gmail.com>
Date: Thu, 26 Jan 2012 23:11:04 +0100 (CET)
Subject: Re: [uml-devel] /sys/class/tty/tty0/active?
From: stian@nixia.no
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "Linux-Arch" <linux-arch@vger.kernel.org>, "Greg KH" <gregkh@suse.de>,
        user-mode-linux-devel@lists.sourceforge.net
User-Agent: SquirrelMail/1.4.8-5.el5_4.10
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!
>
> systemd goes nuts on UML.
> While hunting down all issues I found out that systemd wants to read from
> /sys/class/tty/tty0/active.

Kernel version?
http://comments.gmane.org/gmane.comp.sysutils.systemd.devel/3079 indicates
that the given file appears in 2.6.37

Stian Skjelstad

