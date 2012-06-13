Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2FMGza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:55:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42005 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab2FMGz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:55:29 -0400
Date: Wed, 13 Jun 2012 08:55:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, x86@kernel.org, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
Message-ID: <20120613065525.GA12814@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
	x86@kernel.org, hpa@zytor.com, eranian@google.com,
	linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
 <20120612213905.GE26817@liondog.tnic>
 <4FD7BE15.50604@linux.intel.com>
 <20120612221931.GA4376@liondog.tnic>
 <20120612225344.GE11413@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120612225344.GE11413@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:53:44AM +0200, Andi Kleen wrote:
> I would consider that a BIOS bug.

Ok, but does the user need to know this? If it is of only informative
nature, he can find out each core's ucode version from /proc/cpuinfo so
why do we need to issue this at boot?

-- 
Regards/Gruss,
    Boris.
