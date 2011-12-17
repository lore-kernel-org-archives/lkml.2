Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1LQEqg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 16 Dec 2011 23:46:36 -0500
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:53993 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751153Ab1LQEq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:46:29 -0500
X-AntiVirus: PTMail-AV 0.4-0.97.0
X-Scan-Status: AV clean (0.02405 seconds);
 AS clean (0.07725 seconds);
X-Antivirus-bastov-Mail-From: sergio@serjux.com via serjux.com
X-Antivirus-bastov: 1.25-st-qms (Clear:RC:0(85.240.232.195):SA:1(5.2/5.0):. Processed in 1.078113 secs Process 7284)
Message-ID: <1324097181.25778.23.camel@segulix>
Subject: [Fwd: [Bug 767248] Unable to unsuspended after kernel update to 
 kernel-3.1.5-1.fc16.x86_64]
From: =?ISO-8859-1?Q?S=E9rgio?= Basto <sergio@serjux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dennis Appelon Nielsen <dennis@appelon.net>
Date: Sat, 17 Dec 2011 04:46:21 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems we have a regression on 3.1.4 to 3.1.5 in btrfs 
-------- Forwarded Message --------
From: bugzilla@redhat.com
To: sergio@serjux.com
Subject: [Bug 767248] Unable to unsuspended after kernel update to
kernel-3.1.5-1.fc16.x86_64
Date: Fri, 16 Dec 2011 15:15:48 -0500

Please do not reply directly to this email. All additional
comments should be made in the comments box of this bug.


https://bugzilla.redhat.com/show_bug.cgi?id=767248

--- Comment #21 from Dennis Appelon Nielsen <dennis@appelon.net> 2011-12-16 15:15:46 EST ---
(In reply to comment #16)
> (In reply to comment #13)
> > I have to point out, that this error also could have something to do with
> > changes to btrfs in kernel-3.1.5.1, sense I'm running btrfs on all my
> > partitions, this also could cause the problem with unsuspended
> 
> could be interesting, bisect the patch
> /pub/linux/kernel/v3.0/incr/patch-3.1.4-5.bz2, and find out what commit break
> it yours suspend ,
> because is a regression. and upstream the bug .

Yes, but how do I do this in piratical?

-- 
Configure bugmail: https://bugzilla.redhat.com/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.

-- 
Sérgio M. B.



