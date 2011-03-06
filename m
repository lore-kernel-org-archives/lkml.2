Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1CFVmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 16:42:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1CFVmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 16:42:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] 2.6.38-rc7-git4: Reported regressions from 2.6.37
Date: Sun, 6 Mar 2011 22:42:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Pine.LNX.4.44L0.1103061041440.13175-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103061041440.13175-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103062242.22445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 06, 2011, Alan Stern wrote:
> On Sun, 6 Mar 2011, Rafael J. Wysocki wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29902
> > Subject		: System suspend failed after 1-2 successful resumes
> > Submitter	: Alex Terekhov <a.terekhov@gmail.com>
> > Date		: 2011-02-25 22:24 (10 days old)
> 
> As far as I know, this isn't a regression.  Most likely it is present 
> in earlier kernels too, but the OP hasn't tried any.
> 
> Anyway, it appears to be a combination of problems.  One is a bug, for 
> which a patch has been written and will be submitted soon.  The other 
> is unclear, it is probably a hardware issue.

OK, thanks for the info.

Rafael

