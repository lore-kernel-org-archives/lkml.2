Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0LNEXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:23:13 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:58821 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab0LNEXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:23:12 -0500
Date: Mon, 13 Dec 2010 23:22:42 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: =?ISO-8859-15?Q?CS=C9CSY_L=E1szl=F3?= <boobaa@frugalware.org>
Cc: Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, gorcunov@gmail.com,
        aris@redhat.com, peterz@infradead.org, Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-15?Q?VAJNA_Mikl=F3s?= <vmiklos@frugalware.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.36 does not boot properly
In-reply-to: <201012130019.41234.boobaa@frugalware.org>
Message-id: <alpine.LFD.2.00.1012132321380.16730@x980>
References: <201012130019.41234.boobaa@frugalware.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kernel (hd0,1)/boot/vmlinuz root=/dev/sda2 ro showopts ide=nodma apm=off \
> acpi=off vga=normal noresume selinux=0 barrier=off nosmp noapic maxcpus=0

which of these boot options is mandatory to allow the kernel to boot?

thanks,
Len Brown, Intel Open Source Technology Center


