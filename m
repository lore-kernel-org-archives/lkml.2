Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab1KUWVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:21:00 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64091 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1KUWU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:20:58 -0500
MIME-Version: 1.0
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 14:20:35 -0800
X-Google-Sender-Auth: auF6MuVIUW6G_BkONicwXiKWj_c
Message-ID: <CA+55aFyceMKgS-YRv=r=FrHQ1P9=z7=2PC5gvZcCHoYKnzn_Aw@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ari Savolainen <ari.m.savolainen@gmail.com>
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
> Subject    : lockdep warning after aa6afca5bcab: "proc: fix races against execve() of /proc/PID/fd**"
> Submitter  : Ari Savolainen <ari.m.savolainen@gmail.com>
> Date       : 2011-11-08 3:47
> Message-ID : CAEbykaXYZEFhTgWMm2AfaWQ2SaXYuO_ypTnw+6AVWScOYSCuuw@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132072413125099&w=2

Commit aa6afca5bcab was reverted by commit 5e442a493fc5, so this one
is presumably stale.

                      Linus
