Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1GOSvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:51:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357Ab1GOSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:51:22 -0400
Date: Fri, 15 Jul 2011 11:50:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Theodore Tso <tytso@MIT.EDU>,
        Mike Waychison <mikew@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-Id: <20110715115051.02c013b0.akpm@linux-foundation.org>
In-Reply-To: <20110715155835.4e019ca5@lxorguk.ukuu.org.uk>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<20110714212113.GA28639@suse.de>
	<CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
	<20110715064147.GA1021@suse.de>
	<C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
	<20110715145132.GA4296@suse.de>
	<20110715155835.4e019ca5@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011 15:58:35 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > But none of them are on the Signed-off-by: line area, right?
> 
> We have a fair number of people using things like
> 
> Fixes-bug: [URL]

I use

	Addresses http://bugzilla....

> Its useful public info, it makes it easier to grep

I don't think this issue is worth the knicker-knotting.  If someone
really wants to see the original report they can send an email to the
patch author asking for it, shrug.  If the organization-specific tag
is omitted, they'd never think to do that.

What concerns me more (and which happens a lot more often) is people
forgetting to include any reference to the original bug report.  And
people forgetting Reported-by:.

