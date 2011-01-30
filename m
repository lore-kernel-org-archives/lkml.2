Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1A3T5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:57:37 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:41548 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1A3T5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:57:35 -0500
Date: Sun, 30 Jan 2011 20:57:24 +0100
From: matthieu castet <castet.matthieu@free.fr>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [RFC] merge 32/64 bits realmode wakeup code
Message-ID: <20110130205724.2c3f7541@mat-laptop>
In-Reply-To: <4D44AE75.6020803@zytor.com>
References: <4D41EA12.1030402@free.fr>
	<201101272354.00042.rjw@sisk.pl>
	<4D447C00.70709@free.fr>
	<201101292215.57292.rjw@sisk.pl>
	<4D44AE75.6020803@zytor.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 29 Jan 2011 16:19:01 -0800,
"H. Peter Anvin" <hpa@zytor.com> a écrit :

> On 01/29/2011 01:15 PM, Rafael J. Wysocki wrote:
> >
> > That's correct, but those changes can wait.  The most urgent thing
> > is to fix the resume regression at hand.  I guess we should ask the
> > reporter's in https://bugzilla.kernel.org/show_bug.cgi?id=27472 to
> > test that patch, right?
> >
> 
> By the way, guys: I'm on vacation at the moment, but I do monitor
> this thread.  I think at this point we should revert NX for the low 1
> MiB and worry about doing it properly for .39.

So #9 patch in https://bugzilla.kernel.org/show_bug.cgi?id=27472 is
okay, do you want some cleanup ?


Matthieu
