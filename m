Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0GRQWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 12:22:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab0GRQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 12:22:43 -0400
Date: Sun, 18 Jul 2010 18:22:39 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
Message-ID: <20100718162239.GA21151@fancy-poultry.org>
References: <20100713185816.2866.17837.stgit@localhost.localdomain>
 <20100713185957.2866.50995.stgit@localhost.localdomain>
 <20100714160704.GA10473@kryptos.osrc.amd.com>
 <20100714232201.00433aa9@hammerfall>
 <20100714233102.0f64614b@hammerfall>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714233102.0f64614b@hammerfall>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:jyFwC+dgS/q3H4IeMvQR0iSSo1Vjl+F774HaxqSS/Ug
 5VO89iYgDWPUMUZSwNtkYczZx5WwALamD61kHEdITmLVubpPFs
 wsbHCYSEAP0zlBKk2JhTEzE1mA1g+SFE8Dasn8rcxnzYZygtjY
 SxElEQ6is09D6iEaU62QVgX8SRI2aE0a9UuXQEePArnnBPS8p0
 /v3ffsYABaSdCJipWgaRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.07.2010, Michal Schmidt wrote: 

> This suggests that another way to fix my problem would be this (tested):
[....]

Did apply this patch to stock 2.6.35-rc5, it does _not_ fix my C1E problem.
It takes a lot of key pressing in the boot process to get the system up,
just as it has been before.

(I'll post my dmesg with your debugging patch applied in another mail.)

