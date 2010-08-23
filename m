Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0HWMmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:42:39 -0400
Received: from tex.lwn.net ([70.33.254.29]:48640 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HWMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:42:36 -0400
Date: Mon, 23 Aug 2010 06:42:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Joseph Chan <JosephChan@via.com.tw>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Erik-Jan Post <ej.lfs@xs4all.nl>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/2] drivers/video: Removing dead FB_VIA_CAMERA config
 option
Message-ID: <20100823064233.51889684@bike.lwn.net>
In-Reply-To: <896537c6f9bd2e4babcb9ff4681bb4db72daf544.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<896537c6f9bd2e4babcb9ff4681bb4db72daf544.1282554255.git.qy03fugy@stud.informatik.uni-erlangen.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 11:59:41 +0200
Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de> wrote:

> CONFIG_FB_VIA_CAMERA doesn't exist in Kconfig, therefore removing
> all references to it from the source.

The driver using this option has been posted to the lists a few times.
I have been unforgivably slow in dealing with some review comments, and
so missed the 2.6.36 merge window.  I don't plan to let that happen
again, though.  So my preference would be to leave this code in place;
if it goes away, I'll just have to put it back.

Thanks,

jon
