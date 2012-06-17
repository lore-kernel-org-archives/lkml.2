Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2FQKbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:31:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50498 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2FQKbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:31:10 -0400
Date: Sun, 17 Jun 2012 12:31:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120617103106.GA31534@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
 <Pine.LNX.4.44L0.1206161617080.819-100000@netrider.rowland.org>
 <20120616230706.GA26955@liondog.tnic>
 <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 01:21:29PM +1000, Bojan Smojver wrote:
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
> Yeah, we already have a variable for that. But, we can just do it
> simpler - paint one dot every 10% or something, without any backspaces.
> That will fix it for sure.

Right, this could work too. Whatever you guys decide, I'm here to test
patches :)

Thanks.

-- 
Regards/Gruss,
    Boris.
