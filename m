Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2GTNJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:09:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62601 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2GTNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120720130359.GB18121@x1.osrc.amd.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
	<20120720125213.GA17647@x1.osrc.amd.com>
	<CACVXFVOkiAhiyqnFKyXCrYHPjqRS7E0=iqYOB0r6cbQLOUeTXQ@mail.gmail.com>
	<20120720130359.GB18121@x1.osrc.amd.com>
Date: Fri, 20 Jul 2012 21:09:10 +0800
Message-ID: <CACVXFVPpo2g64YiAEHj184ApjO99yEuQK7tS4Txkj8C4vRVHPg@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
From: Ming Lei <tom.leiming@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 9:03 PM, Borislav Petkov <bp@alien8.de> wrote:
> This still doesn't change the fact that SYSTEM_SUSPEND or
> SYSTEM_SUSPEND_DISK is unused. IOW, both states are unused. So why
> introduce a new state instead of simply test != SYSTEM_RUNNING?

Because system_state is still SYSTEM_RUNNING during S2R or hibernation.

Thanks,
-- 
Ming Lei
