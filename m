Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2KLVlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:41:25 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49848 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KLVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:41:24 -0500
Date: Mon, 12 Nov 2012 13:41:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Artem S. Tashkinov" <t.artem@lycos.com>
cc: linux-kernel@vger.kernel.org, dave@gnu.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: OOM changes in Linux 3.7 lead to udev warnings and total breakage
 of KDE 3.5.10/TDE
In-Reply-To: <545706980.41498.1352739027798.JavaMail.mail@webmail19>
Message-ID: <alpine.DEB.2.00.1211121339000.23347@chino.kir.corp.google.com>
References: <545706980.41498.1352739027798.JavaMail.mail@webmail19>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Artem S. Tashkinov wrote:

> Hello,
> 
> If I remember correctly kernel developers promised not to break user APIs in the Linux kernel
> however in Linux 3.7 a /proc/<PID>/oom_adj file has been totally removed which makes KDE 3.5.x
> (and I suppose TDE) unusable as they depend on this file and simply refuse to start in its absence.
> 

This is 
http://mail.kde.org/pipermail/unassigned-bugs/2010-December/016850.html 
from almost two years ago.  The tunable had been on the feature removal 
schedule for two years and would have emitted a warning if you had run on 
any kernel during that time.  KDE 4.6.1 and later from two years ago work 
fine.

> Also, udev in CentOS/RHEL/Scientific and other old Linux'es depend on this file (which is not critical
> but not pleasant anyway).
> 

Fixed in udev v162 at the same time kde was.
