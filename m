Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1KUWHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:07:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44831 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab1KUWHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:07:43 -0500
MIME-Version: 1.0
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 14:07:20 -0800
X-Google-Sender-Auth: cR0wGfvawk9d7aC6OmchbsUJLi8
Message-ID: <CA+55aFxv7+Kf=sRj7RCSeY0dcVFMcUiXVKT=CY-2aFti5bO4yA@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
> Subject    : Simultaneous cat and external keyboard input causing kernel panic
> Submitter  : Timo Jyrinki <timo.jyrinki@gmail.com>
> Date       : 2011-11-03 12:14
> Message-ID : CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com
> References : http://marc.info/?l=linux-kernel&m=132032253903074&w=2

So while funny, I doubt this is actually a bug. It's a feature, as
pointed out by Clemens Ladisch in that thread.

It's simply sysrq-c: "perform a system crash by a NULL pointer dereference".

Now, I'm perfectly willing to consider that feature to be a
mis-feature, and that this should be considered a bug to be fixed. But
it is not a regression.

Keeping it on the regression list just because it is amusing is
understandable, though ;)

                    Linus
