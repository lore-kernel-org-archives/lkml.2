Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1A2HXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 02:23:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44360 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1A2HXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 02:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g+kQwaqMGObuRtGHYfhegtCJD7kiUaC21AH0q7zS54IsZKxAa/WshSvNiF6wMUh2oE
         /U+6q8LWbT9V3pAWoaHyoErbKGmOKrGPIF0awWtnXUgT2ls903NdHfRUBa7go9cq9fQp
         iKbkSf2AXa0avj4+798nOMy5xTkRiW0SNjoqo=
Date: Fri, 28 Jan 2011 23:23:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.38-rc2
Message-ID: <20110129072324.GA26915@core.coreip.homeip.net>
References: <20110107065448.GC29038@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107065448.GC29038@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Nothing interesting, just
small fixups for recent breakages.

Thanks!

Changelog:
---------

Alexandre Peixoto Ferreira (2):
      Input: synaptics - fix reconnect logic on MT devices
      Input: synaptics - retry failed resets when reconnecting

Rakesh Iyer (2):
      Input: tegra-kbc - fix build error
      Input: tegra-kbc - fix keymap entry for LeftMeta key


Diffstat:
--------

 drivers/input/keyboard/tegra-kbc.c |    6 +++---
 drivers/input/mouse/synaptics.c    |   32 ++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 11 deletions(-)

-- 
Dmitry
