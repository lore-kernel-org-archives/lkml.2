Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0COTfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:35:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0COTfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:35:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
       Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: ACPI patches for Linux-2.6.34-rc1
Date: Mon, 15 Mar 2010 20:38:47 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1003142155470.19244@sony> <b170af451003142310i3fe61282pb6536f6d2000c9c8@mail.gmail.com>
In-Reply-To: <b170af451003142310i3fe61282pb6536f6d2000c9c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003152038.47124.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 March 2010, Rafał Miłecki wrote:
> 2010/3/15 Len Brown <lenb@kernel.org>:
> > Hi Linus,
> >
> > please pull from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> >
> > Here is why three things included in this request
> > look somewhat "merge-windo-ish".
> 
> Len, you seem to hardly ignore
> [PATCH] ACPI / PM: Move ACPI video resume to a PM notifier
> 
> AFAIK this didn't hit rc1, is not included in this patchset and we
> couldn't get any response from you in this thread.

I wanted to mention that too.  Here's the patchwork link:

http://patchwork.kernel.org/patch/83479/

Len, if you want me to push it myself, I can do that.

Thanks,
Rafael
