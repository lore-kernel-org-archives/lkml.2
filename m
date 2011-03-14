Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab1CNWTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:19:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab1CNWTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:19:37 -0400
Date: Mon, 14 Mar 2011 15:18:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net, rtc-linux@googlegroups.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        security@kernel.org
Subject: Re: [Security] [PATCH 00/20] world-writable files in sysfs and
 debugfs
Message-Id: <20110314151832.3a6e3072.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
References: <cover.1296818921.git.segoon@openwall.com>
	<AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Mar 2011 23:23:06 +0300
Vasiliy Kulikov <segoon@openwall.com> wrote:

> > Vasiliy Kulikov (20):
> >  mach-ux500: mbox-db5500: world-writable sysfs fifo file
> >  leds: lp5521: world-writable sysfs engine* files
> >  leds: lp5523: world-writable engine* sysfs files
> >  misc: ep93xx_pwm: world-writable sysfs files
> >  rtc: rtc-ds1511: world-writable sysfs nvram file
> >  scsi: aic94xx: world-writable sysfs update_bios file
> >  scsi: iscsi: world-writable sysfs priv_sess file
> 
> These are still not merged :(

I grabbed them and shall merge some and send others at relevant
maintainers, thanks.

