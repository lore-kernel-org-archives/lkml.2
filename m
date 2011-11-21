Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab1KUWS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:18:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1KUWSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:18:53 -0500
MIME-Version: 1.0
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 14:18:29 -0800
X-Google-Sender-Auth: O8gTSl7UkMRuUIQ32xqYgUhcbbs
Message-ID: <CA+55aFygSFt+O5KLoiE_0V+o45eKfsoDDV5ML8EF=J0n9z_D-Q@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Mon, Nov 21, 2011 at 1:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Subject    : hugetlb oops on 3.1.0-rc8-devel
> Submitter  : Andy Lutomirski <luto@amacapital.net>
> Date       : 2011-11-01 22:20
> Message-ID : CALCETrW1mpVCz2tO5roaz1r6vnno+srHR-dHA6_pkRi2qiCfdw@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132018604426692&w=2

Despite the subject line, that's not an oops, it's a BUG_ON().

And it *should* be fixed by commit ea4039a34c4c ("hugetlb: release
pages in the error path of hugetlb_cow()") although I don't think Andy
ever confirmed that (since it was hard to trigger).

                     Linus
