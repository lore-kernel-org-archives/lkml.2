Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1GCUwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:52:25 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:52759 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1GCUwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:52:23 -0400
Date: Sun, 3 Jul 2011 22:52:12 +0200
From: matthieu castet <castet.matthieu@free.fr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] merge 32 and 64 realmode wakeup code
Message-ID: <20110703225212.77311f51@mat-laptop>
In-Reply-To: <201107030850.32457.rjw@sisk.pl>
References: <1309628621-23107-1-git-send-email-castet.matthieu@free.fr>
	<4E0F9C3F.8020907@zytor.com>
	<201107030850.32457.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le Sun, 3 Jul 2011 08:50:32 +0200,
"Rafael J. Wysocki" <rjw@sisk.pl> a écrit :

> On Sunday, July 03, 2011, H. Peter Anvin wrote:
> > On 07/02/2011 10:43 AM, Matthieu CASTET wrote:
> > > - this mean less ifdef in code
> > > - we could remove now unused field in wakeup_header (pmode_*)
> > > 
> > > Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> > > ---
> > >  arch/x86/kernel/acpi/realmode/wakeup.S |   26
> > > -------------------------- arch/x86/kernel/acpi/sleep.c
> > > |   27 ++++++++++-----------------
> > > arch/x86/kernel/trampoline_32.S        |    4 ---- 3 files
> > > changed, 10 insertions(+), 47 deletions(-)
> > > 
> > 
> > Looks great to me.  Rafael?
> 
> I don't have any immediate complaints.  Please feel free to add my ACK
> to the patches.
> 
Thanks,

Should I repost the patches with our ack somewhere ?


Matthieu
