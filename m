Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0LOHoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 02:44:13 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:32809 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753434Ab0LOHoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 02:44:12 -0500
Date: Wed, 15 Dec 2010 08:39:20 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: [PATCH] base: add sysfs socs info
Message-ID: <20101215073920.GU19897@game.jcrosoft.org>
References: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
 <20101214161130.GB1857@suse.de>
 <20101215012511.GQ19897@game.jcrosoft.org>
 <20101215034713.GB3297@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215034713.GB3297@suse.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8196832797711575952
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.500023/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > Also, isn't this information already in /proc/cpu/ today?
> > no all this information are not present in /proc/cpu and a cpu is not a soc
> > 
> > basicaly on a board you will have one soc but some boards have more as example
> > some ST boards you have two sh4 soc or on some amcc you have two powerpc soc
> > 
> > with these information you are allow to dynamise the userspace based on the
> > soc or the companion soc and also be able to display this information in a UI
> 
> Ok, but then why not make it "real" devices and not sysdev?  We are
> trying to fix the sysdev code to be semi-real devices, so you might as
> well make them real ones now.
ok I base my work on drivers/base/cpu.c

where we also use sysdev

can we point me a code how you want I implement it

Best Regards,
J.
