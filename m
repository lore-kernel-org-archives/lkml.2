Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0DVQON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:14:13 -0400
Received: from hofr.at ([212.69.189.236]:41622 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab0DVQOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:14:11 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 12:14:11 EDT
Date: Thu, 22 Apr 2010 18:07:23 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-kernel@vger.kernel.org
Subject: defconfig strangeness
Message-ID: <20100422160723.GA13848@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


HI !

 doing a series of static code analysis on 2.6.34-rcX each of them with 
 defconfig (x86 32bit) - the strangeness is that even though the config
 file is the same for rc3...5 the number of files actually compiled 
 is very different. (linux-2.6 git tree)

 2.6.34-rc5 1695
 2.6.34-rc4 3404
 2.6.34-rc3 5109

 I diffed the .configs - rc4/rc5 only shows

3,4c3,4
< # Linux kernel version: 2.6.34-rc4
< # Thu Apr 22 11:37:43 2010
---
> # Linux kernel version: 2.6.34-rc5
> # Thu Apr 22 10:44:02 2010

 why then this large difference in files being compiled ? 

 any hint apprecieated.

thx!
hofrat
