Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2KSOXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:23:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42074 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2KSOXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:23:10 -0500
Date: Mon, 19 Nov 2012 15:23:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h
 processors
Message-ID: <20121119142322.GB8501@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Gene Heskett <gheskett@wdtv.com>,
	Andreas Herrmann <herrmann.der.user@googlemail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Boris Ostrovsky <boris.ostrovsky@amd.com>, hpa@zytor.com,
	mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
 <201211151801.23160.gheskett@wdtv.com>
 <20121117195438.GB2375@tweety>
 <201211171511.13183.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201211171511.13183.gheskett@wdtv.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 03:11:12PM -0500, Gene Heskett wrote:
> I did, it worked and I have now put it in rc.local for the next reboot.

You can always install msr-tools on your box and do as root:

# rdmsr 0x8b

to get the current microcode revision.

-- 
Regards/Gruss,
Boris.
