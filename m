Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0FGTCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:02:54 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50812 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752555Ab0FGTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:02:53 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [RFC] Save/restore MISC_ENABLE register
Date: Mon, 7 Jun 2010 21:02:43 +0200
User-Agent: KMail/1.9.10
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201006071814.53583.linux@rainbow-software.org> <201006072051.10421.linux@rainbow-software.org> <4C0D4032.6020907@zytor.com>
In-Reply-To: <4C0D4032.6020907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006072102.46728.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 June 2010 20:53:38 H. Peter Anvin wrote:
> On 06/07/2010 11:51 AM, Ondrej Zary wrote:
> > Something like this?
> >
> > Save/restore MISC_ENABLE register on suspend/resume.
> > This fixes OOPS (invalid opcode) on resume from STR on Asus P4P800-VM,
> > which wakes up with MWAIT disabled.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> Yes, that's a lot better.
>
> I presume you have tested it.  Rafael, do you want to take this or should
> I?

Yes, it works on the P4P800-VM. Don't have any x86_64 machine to test.

-- 
Ondrej Zary
