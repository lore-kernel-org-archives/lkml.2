Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1GKVSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:18:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54071 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1GKVSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <XNkIyhV6dgF.A.D4G.TCYGOB@chimera>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
	<XNkIyhV6dgF.A.D4G.TCYGOB@chimera>
Date: Mon, 11 Jul 2011 14:18:48 -0700
X-Google-Sender-Auth: VPg3EEMvHhJgdjeILH_X5zU-yoY
Message-ID: <CAA9_cmeY1Q-L_iMQfsf-KWufZzpkMSWzQ42ep=bQP9XZwyV-Lw@mail.gmail.com>
Subject: Re: [Bug #38522] address space collision error message on boot
From: Dan Williams <dan.j.williams@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jools Wills <jools@oxfordinspire.co.uk>, bhelgaas@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Bjorn ]

On Sun, Jul 10, 2011 at 3:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).

The patch from the bugzilla entry is not yet upstream.

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38522
> Subject         : address space collision error message on boot
> Submitter       : Jools Wills <jools@oxfordinspire.co.uk>
> Date            : 2011-06-29 02:28 (12 days old)
> First-Bad-Commit: http://git.kernel.org/linus/5d94e81f69d4b1d1102d3ab557ce0a817c11fbbb

Per the commentary in the bugzilla this commit makes the warning
message appear on 64-bit builds, but 32-bit has the same problem on
affected platforms (without the commit).

Bjorn has a proposed patch [1] that just downgrades the warning since
system operation does not appear to be affected.

--
Dan

[1]: https://bugzilla.kernel.org/attachment.cgi?id=64102
