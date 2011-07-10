Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1GJKzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:55:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49059 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab1GJKzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
References: <Y7LyOsOBwFM.A.kJG.kBYGOB@chimera>
Date: Sun, 10 Jul 2011 13:55:11 +0300
X-Google-Sender-Auth: A1_jmMKOePKz1zxuapzHKdapNAY
Message-ID: <CAOJsxLEzUC9k0Y2PNxQpCs0WCjQBmP0O2dDxTzPzhGEcvQVDeQ@mail.gmail.com>
Subject: Re: 3.0-rc6-git6: Reported regressions from 2.6.39
From: Pekka Enberg <penberg@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Steve <stefan.bosak@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 1:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38672
> Subject         : KVM guest boot crashed
> Submitter       : Steve <stefan.bosak@gmail.com>
> Date            : 2011-07-02 06:56 (9 days old)
> First-Bad-Commit: http://git.kernel.org/linus/6506e4f995967b1a48cc34418c77b318df92ce35

That URL gives me "404 - Unknown commit object" and Bugzilla comments
give me the impression it's actually a QEMU bug. Hmm?
