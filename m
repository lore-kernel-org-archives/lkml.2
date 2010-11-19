Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0KSAg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:36:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab0KSAg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
Date: Thu, 18 Nov 2010 16:36:54 -0800
Message-ID: <AANLkTinzHyWcfS++R_d+yqR9JQu7W51h0XRr-ikd_6y1@mail.gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
From: Jesse Gross <jesse@nicira.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 3:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=20462
> Subject         : 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
> Submitter       : Nikola Ciprich <extmaillist@linuxbox.cz>
> Date            : 2010-10-15 7:10 (35 days old)
> Message-ID      : <20101015071008.GA8714@pcnci.linuxbox.cz>
> References      : http://marc.info/?l=linux-kernel&m=128712984831303&w=2

A fix for this has been sent to -stable:
http://www.spinics.net/lists/netdev/msg146227.html
