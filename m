Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0KJEFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 23:05:47 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:56978
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab0KJEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 23:05:45 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 23:05:44 EST
Date: Wed, 10 Nov 2010 12:58:33 +0900
From: Mattia Dongili <malattia@linux.it>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101110035833.GB3029@kamineko.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
X-Operating-System: Linux 2.6.35+ x86_64
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:29:15PM +0900, Norbert Preining wrote:
> Hi Mattia, hi all,
> 
> (please keep me in Cc)
> 
> when switching from 2.6.36 to 2.6.37-rc1(+git) I realize that I cannot
> adjust the backlight anymore. Before this was possible with the
> Fn-F5 and Fn-F6 keys, but now nothing happens.

It's ages sony_laptop doesn't change, it may be some other change in the
acpi layer that causes this.

> acpi_listen does not issue anything when these keys are pressed.

How about the input layer? /proc/acpi/event is deprecated and you should
not rely on that.
But anyway, it's a Fn key issue, not backlight control itself, right?
Can you change brightness echoing to the sysfs files directly?

> Is there any obvious oversight from my side?

don't know, can you bisect it?

> config is attached.

can you attach dmesg output after loading sony_laptop with debug=1 and
pressing the brightness keys?
-- 
mattia
:wq!
