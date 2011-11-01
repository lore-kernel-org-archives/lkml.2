Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1KAKQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:16:01 -0400
Received: from serv04.lahn.de ([213.239.197.57]:34777 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1KAKQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:16:01 -0400
Date: Tue, 1 Nov 2011 11:14:20 +0100
From: Michael Leun <ml@newton.leun.net>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        nigel@tuxonice.net
Subject: What about bugzilla.kernel.org / Bug 37142 / Tuxonice developer
 going to quit development
Message-ID: <20111101111420.1667f3aa@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any timeline for bringing bugzilla.kernel.org up again?


I'm mainly asking because I was tracking 

Bug 37142 – [GM965/KMS/UXA] memory corruption on resume from hibernate

a memory corruption issue which is around for quite some time, see

http://thread.gmane.org/gmane.linux.kernel/1116939/focus=1117113

that was March 2011. I suspect this bug might be there since
introduction of KMS.

My workaround since I noticed that bug was to use tuxonice for suspend
to disk, what works perfectly (that in particular means without memory
corruption), but unfortunately the current developer of tuxonice, Nigel
Cunningham is going to stop development, see

http://lists.tuxonice.net/pipermail/tuxonice-users/2011-November/000945.html


Rafael, Richard: What do you think is the current state of this bug?
Was it ever fixed for you?

As far as I remember in bugzilla 37142 there were patches floating
around, but they did'nt make any change for me. I didn't notice any
change on that bug until kernel.org went down due to that security
issue.

At the moment I'm compiling a vanilla 3.1 to see if I still see this
bug.

-- 
MfG,

Michael Leun

