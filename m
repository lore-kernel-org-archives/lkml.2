Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1FAGsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:48:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52429 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1FAGs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:48:29 -0400
Date: Wed, 1 Jun 2011 08:48:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some x86, asm cleanups
Message-ID: <20110601064826.GA3368@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
 <4DE59E9E.5030802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DE59E9E.5030802@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:06:22PM -0700, H. Peter Anvin wrote:
> On 05/31/2011 01:21 PM, Borislav Petkov wrote:
> > Hi,
> > 
> > here are a couple of asm cleanups. I hope I don't break some esoteric
> > gas version with them. They survived booting into kvm and on a couple of
> > different machines so I might get lucky.
> > 
> > Suggestions welcome, as always.
> > 
> > Thanks.
> 
> Any way you can try them out on the gas version from hell[TM], a.k.a. 2.16?

Yeah, let me see what I can do. I remember vaguely that my colleague had
problems with some asm changes when building the kernel on suse and one
of their versions should have that bat from hell.

I'll let you know.

-- 
Regards/Gruss,
    Boris.
