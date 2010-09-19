Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0ISUPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:15:41 -0400
Received: from mx.ij.cx ([212.13.201.15]:62403 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751015Ab0ISUPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 16:15:40 -0400
Date: Sun, 19 Sep 2010 21:15:37 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
cc: linux-kernel@vger.kernel.org
Subject: make headers_install
Message-ID: <alpine.LNX.2.01.1009192055520.28631@fgnk.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.28.218.61
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, I tried to update my kernel headers using the instructions in 
Documentation/make/headers_install.txt. I followed the example:

  make headers_install INSTALL_HDR_PATH=/usr/include

but it installed them in /usr/include/include. So I modified the path:

  make headers_install INSTALL_HDR_PATH=/usr

The command installed the headers, but then automatically deleted 
/usr/include/*.h (nasty!). This is with kernel 2.6.35.4.

Do the docs need an update (and I should always be installing to a staging 
area?) Or is this a bug in the process -- where is should be removing 
unknown files in /usr/include/linux or similar?

I seem to remember that I used to be able to install headers direct to the 
system, is this still the case?

Thanks

-- 
Mark
