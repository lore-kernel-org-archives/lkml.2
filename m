Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2EUVsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:48:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759290Ab2EUVsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:48:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Mon, 21 May 2012 23:53:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <201205211518.39137.rjw@sisk.pl> <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com>
In-Reply-To: <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205212353.42639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2012, Bojan Smojver wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >No, I'm not going to put that into 3.5, sorry.  It can go into 3.6.
> 
> May I ask why? I do not see why people should wait another few months to get this.

We haven't had it for the last few years, so a couple of months won't make
a big difference I think.

The reason is that I want it to get more testing and the merge window has
already opened, so it's not a good time for adding new features to linux-next.
It's not urgent and it _can_ wait.

Thanks,
Rafael
