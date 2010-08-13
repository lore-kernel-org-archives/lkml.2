Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153Ab0HMJeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:34:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:56632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934042Ab0HMJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:34:41 -0400
Subject: Re: [PATCH] ideapad-laptop: add new driver
From: David Woodhouse <dwmw2@infradead.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C650FFB.7090602@canonical.com>
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
	 <1281690893.23680.475.camel@localhost>  <4C650FFB.7090602@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 10:34:38 +0100
Message-ID: <1281692078.23680.487.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 17:27 +0800, Ike Panhc wrote:
> Yes, IIRC EC will send i8042 keycode when you booting with QS button, not
> with power button. atkbd.c reports unknown key after booting with QS button. 

That's interesting. I don't *ever* boot with the QS button; I get the
keycodes when I boot normally. I tried the QS button precisely once, but
only *after* I blew away the original contents of the hard drive with my
MeeGo installation, so it didn't boot.

Do you know how to restore it? Or do you have a copy of the 'lenovo-ec'
module that it apparently contains?

I did keep the Windows restore partition, just in case I needed to go
back to it to get wireless working. But when I tried to recover, it told
me it didn't like my partition table -- so I fixed that and next time I
booted into the OS recovery, it just dumped me at a command prompt and
didn't even manage to start the graphical recovery tool.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

