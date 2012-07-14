Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2GNKT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 06:19:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2GNKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 06:19:54 -0400
Date: Sat, 14 Jul 2012 12:19:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Davidlohr Bueso <dave@gnu.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, amd: rename vmmu support capability
Message-ID: <20120714101951.GB26559@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Davidlohr Bueso <dave@gnu.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
	kvm list <kvm@vger.kernel.org>, x86@kernel.org
References: <1342202575.2706.4.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342202575.2706.4.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 08:02:55PM +0200, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> AMD has renamed nested page table technology to rapid virtualization indexing,
> reflect this change in the kernel.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

You know that /proc/cpuinfo is a userspace ABI, right?

And are you sure nothing is using that string -
"npt" - since it got added almost three years ago by
414bb144efa2d2fe16d104d836d0d6b6e9265788?

-- 
Regards/Gruss,
    Boris.
