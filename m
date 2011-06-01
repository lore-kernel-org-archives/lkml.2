Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab1FAUk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:40:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37504 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759810Ab1FAUk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:40:26 -0400
Date: Wed, 1 Jun 2011 22:40:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some x86, asm cleanups
Message-ID: <20110601204022.GB25030@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
 <4DE59E9E.5030802@zytor.com>
 <820d76c11c182f41dcbc652926e27d94.squirrel@www.skyhub.de>
 <4DE682C0.9060208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DE682C0.9060208@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 11:19:44AM -0700, H. Peter Anvin wrote:
> >  as --version
> > GNU assembler 2.16.91.0.5 20051219 (SUSE Linux)
> > Copyright 2005 Free Software Foundation, Inc.
> > This program is free software; you may redistribute it under the terms of
> > the GNU General Public License.  This program has absolutely no warranty.
> > This assembler was configured for a target of `x86_64-suse-linux'.
> > 
> > at least this is one incarnation of it. I had to install SLES10 SP3
> > with the unpatched binutils version in kvm to test. And yes, the kernel
> > builds fine. Let me know if I should run some randconfigs, in addition.
> > 
> > Btw, I'm keeping the kvm image for future testing with the bat from hell :).
> > 
> 
> I think 2.16.9x is really 2.17.

Well, this is the one we had problems last time:
http://marc.info/?l=linux-kernel&m=128568422205398&w=2

Do you know per chance a distro version that has the one gas from hell
you mean so I could test with it additionally?

-- 
Regards/Gruss,
    Boris.
