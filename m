Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0GRQjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 12:39:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0GRQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 12:39:48 -0400
Date: Sun, 18 Jul 2010 18:39:23 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100718163923.GA8551@fancy-poultry.org>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713185957.2866.50995.stgit@localhost.localdomain>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:C4XCo2eepaKrfYohmWQOTP3Ku/BqmG0dTlmbyqWvfrj
 +t4MOtVCM7U9pr/kfNKyR2K/vAFnES6Dz/WeVgdT2VaZ0ticE5
 0J2tm4Xl4aRQmgo9rMVZq+upwt8vBPimMXtQD3hagCDLU9bFH2
 AEBXu78L0rrUrVV8M35cke12cFb8BXxjqvkLoS+jFROncw9zaM
 bcKAgf5MQzX4JGx7Qi+wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.2010, Michal Schmidt wrote: 

> On my system with AMD Phenom II X6 I am seeing pauses at boot (usually during
> udev startup) which require a key press to continue. It only happens if C1E is
> enabled in the BIOS.

That's exactly what I see. Unfortunately, this patch doesn't fix it for me
either (applied to 2.6.35-rc5).



