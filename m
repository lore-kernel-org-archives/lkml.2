Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1H1Tho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:37:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43498 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1H1Thj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:37:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: 3.1-rc3-git6: Reported regressions from 3.0
Date: Sun, 28 Aug 2011 21:39:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
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
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <20110828193519.GA14132@redhat.com>
In-Reply-To: <20110828193519.GA14132@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108282139.01189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 28, 2011, Dave Jones wrote:
> On Sun, Aug 28, 2011 at 08:22:05PM +0200, Rafael J. Wysocki wrote:
>  
>  > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41742
>  > Subject		: duplicate filename  for intel_backlight with the i915 driver
>  > Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
>  > Date		: 2011-08-25 18:51 (4 days old)
>  > First-Bad-Commit: http://git.kernel.org/linus/aaa6fd2a004147bf32fce05720938236de3361d9
>  
> this should be fixed by b727d20269e8ef1de002bfea8099f5e9db9e9f23

Thanks, closing.

Rafael
