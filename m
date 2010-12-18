Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0LRPa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:30:27 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:41365 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457Ab0LRPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:30:24 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 16:30:12 +0100
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2 V3] applesmc: Use PnP rather than hardcoding
 resources and devices
Message-ID: <20101218153012.GA1506@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
 <20101218042320.GA14104@ericsson.com>
 <20101218093719.GA1493@polaris.bitmath.org>
 <20101218144329.GB21801@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218144329.GB21801@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTyjf-0008Ac-5O.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PTyjf-0008Ac-5O 638a7de31c978ae3429cbc2c60e02115
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm. Is this an oops or a lockdep warning?

It is a null-pointer dereference in sysfs_create_file(). Probably the
kernel is asking the same question as I did - do you actually see the
sysfs nodes when testing the patch?

> > So where to attach the sysfs nodes... There is also a userspace issue
> > here, since a lot of applications are hard-wired to
> > /sys/devices/platform/applesmc.768/.
> 
> The correct sysfs ABI is to use the /sys/class interface and the names 
> under there rather than assuming a hardwired platform device path.

Still breaks user-space, but it seems this is already under control.

Thanks,
Henrik
