Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2FQDVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 23:21:55 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35012 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab2FQDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 23:21:34 -0400
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <Pine.LNX.4.44L0.1206161617080.819-100000@netrider.rowland.org> <20120616230706.GA26955@liondog.tnic>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120616230706.GA26955@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Sun, 17 Jun 2012 13:21:29 +1000
To: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:

>Ok, I don't know the hibernation code at all but let me give it a try:
>
>how about teach the piece that parses
>
>$ echo suspend > /sys/power/disk
>
>to make a note to self that we're doing the hibrid hibernation method
>and then the function that prints the progress indicator to be let
>known
>of the aforementioned self-note so that it doesn't do any output?
>
>Purely hypothetical, of course.


Yeah, we already have a variable for that. But, we can just do it simpler - paint one dot every 10% or something, without any backspaces. That will fix it for sure.

-- 
Bojan
