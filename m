Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2B2TjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:39:07 -0500
Received: from adamg.eu ([91.192.224.99]:43289 "EHLO adamg.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab2B2TjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:39:06 -0500
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [3.2.2] oom + no-killable-processes.
Date: Wed, 29 Feb 2012 20:38:58 +0100
Message-ID: <9308374.K32OPLuieM@vmx>
User-Agent: KMail/4.8.0 (Linux/3.2.7-1; KDE/4.8.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
 
i've found on my 8-core opterons following oops (oom+nokillable): http://imgbin.org/index.php?page=image&id=6945
usualy the kernel just kills processes from userspace but this time something has gone wrong...
sysrq was dead, so no more stacktraces :/
