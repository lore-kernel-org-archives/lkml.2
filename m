Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0LMVLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:11:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475Ab0LMVLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:11:11 -0500
From: "Rafael J. Wysocki" <rjw@suse.com>
Organization: SUSE Labs
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
Date: Mon, 13 Dec 2010 22:10:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <201012051408.27730.rjw@suse.com> <4D05EFB2.3050703@gmail.com>
In-Reply-To: <4D05EFB2.3050703@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012132210.51325.rjw@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 13, 2010, Jiri Slaby wrote:
> On 12/05/2010 02:08 PM, Rafael J. Wysocki wrote:
> > On Sunday, December 05, 2010, Jiri Slaby wrote:
> >> On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
> >>> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
> >>
> >> Hi, this kernel regresses with respect to resume. It doesn't wake up,
> >> the screen is black with blinking cursor at position [1, 1].
> >> 2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
> >> far.
> >>
> >> I'm using pm-suspend, any ideas what to test before I start to find the
> >> reason on my own?
> > 
> > Please try the pm_test tests for core, processors and devices, eg.:
> 
> Hmm, I haven't seen the issues since then. So it had to be some kind of
> coincidence -- I see the issue occasionally for some time already. Now
> it triggered twice in a row after I updated the kernel.

Hmm.  What hardware is that?

Rafael
