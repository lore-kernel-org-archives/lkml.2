Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2GTM5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:57:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46592 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2GTM5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120720125213.GA17647@x1.osrc.amd.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
	<20120720125213.GA17647@x1.osrc.amd.com>
Date: Fri, 20 Jul 2012 20:57:05 +0800
Message-ID: <CACVXFVOkiAhiyqnFKyXCrYHPjqRS7E0=iqYOB0r6cbQLOUeTXQ@mail.gmail.com>
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

On Fri, Jul 20, 2012 at 8:52 PM, Borislav Petkov <bp@alien8.de> wrote:

> This new SYSTEM_SUSPEND state is declared above and only assigned here
> to system_state without being tested anywhere. AFAICT, the only test
> you're doing is system_state != SYSTEM_RUNNING and that works without
> defining a new SYSTEM_SUSPEND state.
>
> So are you sure you really need it?

If the approach is workable, I will rename SYSTEM_SUSPEND_DISK as
SYSTEM_SUSPEND since SYSTEM_SUSPEND_DISK is not used now.


Thanks,
-- 
Ming Lei
