Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2FQUQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:16:35 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2FQUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:16:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Sun, 17 Jun 2012 22:21:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <20120616230706.GA26955@liondog.tnic> <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
In-Reply-To: <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172221.55493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 17, 2012, Bojan Smojver wrote:
> Borislav Petkov <bp@alien8.de> wrote:
> 
> >Ok, I don't know the hibernation code at all but let me give it a try:
> >
> >how about teach the piece that parses
> >
> >$ echo suspend > /sys/power/disk
> >
> >to make a note to self that we're doing the hibrid hibernation method
> >and then the function that prints the progress indicator to be let
> >known
> >of the aforementioned self-note so that it doesn't do any output?
> >
> >Purely hypothetical, of course.
> 
> 
> Yeah, we already have a variable for that. But, we can just do it
> simpler - paint one dot every 10% or something, without any backspaces.
> That will fix it for sure.

Yeah, that will do.

Thanks,
Rafael
