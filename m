Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0FFTD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:03:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57866 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0FFTDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:03:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm 
 =?utf-8?q?for=09reading_=26_writing_a_hibernation?= image.
Date: Sun, 6 Jun 2010 21:04:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <201006061557.20482.rjw@sisk.pl> <1275839650.5331.2.camel@maxim-laptop>
In-Reply-To: <1275839650.5331.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006062104.55869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010, Maxim Levitsky wrote:
> On Sun, 2010-06-06 at 15:57 +0200, Rafael J. Wysocki wrote: 
> > On Sunday 06 June 2010, Maxim Levitsky wrote:
...
> > So how TuxOnIce helps here?
> Very simple.
> 
> With swsusp, I can save 750MB (memory) + 250 Vram (vram)
> With full memory save I can save (1750 MB of memory) + 250 MB of
> vram....

So what about being able to save 1600 MB total instead of the 2 GB
(which is what we're talking about in case that's not clear)?  Would it
be _that_ _much_ worse?

Rafael
