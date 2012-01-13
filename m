Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2AMNcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:32:00 -0500
Received: from lo.gmane.org ([80.91.229.12]:49008 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2AMNb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:31:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mantas <grawity@gmail.com>
Subject: 3.2-git - freeze during hibernation
Date: Fri, 13 Jan 2012 15:31:44 +0200
Message-ID: <jepbo0$l1e$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
Cc: suspend-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using uswsusp git-17789a0 and Linux git-v3.2-6540-g4c4d285, suspend to
disk freezes right before writing the memory to disk -- "Saving X image
data pages" appears, but the percentage does not, nor is there any disk
activity; all I can do is reboot using Alt+SysRq.

Same version of uswsusp, both suspend to memory and disk, worked
perfectly with Linux v3.2 release and earlier versions. The device is
ASUS K52JT. Any hints?

-- 
Mantas M.

