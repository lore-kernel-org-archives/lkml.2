Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2KQOk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:40:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37314 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2KQOk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:40:56 -0500
Date: Sat, 17 Nov 2012 15:41:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Gene Heskett <gheskett@wdtv.com>
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, herrmann.der.user@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h
 processors
Message-ID: <20121117144117.GD16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Gene Heskett <gheskett@wdtv.com>,
	Boris Ostrovsky <boris.ostrovsky@amd.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>, hpa@zytor.com,
	mingo@elte.hu, tglx@linutronix.de, herrmann.der.user@googlemail.com,
	linux-kernel@vger.kernel.org
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
 <20121115204503.GB18032@khazad-dum.debian.net>
 <201211151801.23160.gheskett@wdtv.com>
 <50A57C35.10906@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50A57C35.10906@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 06:35:17PM -0500, Boris Ostrovsky wrote:
> One possibility is that BIOS already incorporated all patches (which
> typically is the case) and so the driver doesn't have to do anything.

/proc/cpuinfo contains ucode version and the processor's f/m/s, which
is enough information to tell us whether your old phenom needs ucode
patching.

Thanks.

-- 
Regards/Gruss,
Boris.
