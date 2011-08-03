Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HCErW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:47:22 -0400
Received: from knuth.cs.hmc.edu ([134.173.42.100]:49692 "EHLO knuth.cs.hmc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1HCErR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:47:17 -0400
Date: Tue, 2 Aug 2011 22:47:15 -0600
From: Adam Cozzette <acozzette@cs.hmc.edu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: psmouse-base.c: printk messages still list old filename
Message-ID: <20110803044714.GC23520@[192.168.0.12]>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I was looking at drivers/input/mouse/psmouse-base.c and I saw that there are a
number of printk messages that refer to the nonexistent file psmouse.c, e.g.:

    printk(KERN_NOTICE "psmouse.c: %s at %s - driver resynched.\n",
        psmouse->name, psmouse->phys);

I saw on the archives that you had a patch lined up for this last year. Is that
patch still on the way or has it been dropped? I would be happy to provide a new
patch for this if it is still something that needs to be fixed.

Thank you,
Adam

-- 
Adam Cozzette
Harvey Mudd College Class of 2012
