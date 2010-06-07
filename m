Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0FGSyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:54:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0FGSyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:54:14 -0400
Message-ID: <4C0D4032.6020907@zytor.com>
Date: Mon, 07 Jun 2010 11:53:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] [RFC] Save/restore MISC_ENABLE register
References: <201006071814.53583.linux@rainbow-software.org> <4C0D2BFB.2090200@zytor.com> <201006072051.10421.linux@rainbow-software.org>
In-Reply-To: <201006072051.10421.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 11:51 AM, Ondrej Zary wrote:
> 
> Something like this?
> 
> Save/restore MISC_ENABLE register on suspend/resume.
> This fixes OOPS (invalid opcode) on resume from STR on Asus P4P800-VM, which
> wakes up with MWAIT disabled.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 

Yes, that's a lot better.

I presume you have tested it.  Rafael, do you want to take this or should I?

	-hpa
