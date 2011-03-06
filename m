Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1CFPrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 10:47:11 -0500
Received: from netrider.rowland.org ([192.131.102.5]:55181 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752771Ab1CFPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 10:47:08 -0500
Date: Sun, 6 Mar 2011 10:47:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [linux-pm] 2.6.38-rc7-git4: Reported regressions from 2.6.37
In-Reply-To: <t0W8Ea1iKeB.A.6xD.Lp3cNB@chimera>
Message-ID: <Pine.LNX.4.44L0.1103061041440.13175-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29902
> Subject		: System suspend failed after 1-2 successful resumes
> Submitter	: Alex Terekhov <a.terekhov@gmail.com>
> Date		: 2011-02-25 22:24 (10 days old)

As far as I know, this isn't a regression.  Most likely it is present 
in earlier kernels too, but the OP hasn't tried any.

Anyway, it appears to be a combination of problems.  One is a bug, for 
which a patch has been written and will be submitted soon.  The other 
is unclear, it is probably a hardware issue.

Alan Stern

