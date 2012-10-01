Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2JAKHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:07:03 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45041 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab2JAKHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:07:01 -0400
Date: Mon, 1 Oct 2012 12:06:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent AMD MCE oops on multi-server system
Message-ID: <20121001100650.GB4795@aftab.osrc.amd.com>
References: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:42:05PM +0800, Daniel J Blueman wrote:
> When booting on a federated multi-server system, the processor Northbridge
> lookup returns NULL; add guards to prevent this causing an oops.

Interesting.

What does lspci say on those systems?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
