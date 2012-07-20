Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2GTNN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:13:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58715 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2GTNNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:13:25 -0400
Date: Fri, 20 Jul 2012 15:13:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot
 and resume
Message-ID: <20120720131327.GC18121@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ming Lei <tom.leiming@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-usb <linux-usb@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
 <20120720125213.GA17647@x1.osrc.amd.com>
 <CACVXFVOkiAhiyqnFKyXCrYHPjqRS7E0=iqYOB0r6cbQLOUeTXQ@mail.gmail.com>
 <20120720130359.GB18121@x1.osrc.amd.com>
 <CACVXFVPpo2g64YiAEHj184ApjO99yEuQK7tS4Txkj8C4vRVHPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACVXFVPpo2g64YiAEHj184ApjO99yEuQK7tS4Txkj8C4vRVHPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 09:09:10PM +0800, Ming Lei wrote:
> On Fri, Jul 20, 2012 at 9:03 PM, Borislav Petkov <bp@alien8.de> wrote:
> > This still doesn't change the fact that SYSTEM_SUSPEND or
> > SYSTEM_SUSPEND_DISK is unused. IOW, both states are unused. So why
> > introduce a new state instead of simply test != SYSTEM_RUNNING?
> 
> Because system_state is still SYSTEM_RUNNING during S2R or hibernation.

Ah, and you change that in suspend_devices_and_enter().

Ok, thanks.

-- 
Regards/Gruss,
Boris.
