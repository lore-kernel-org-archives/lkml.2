Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2GNO3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 10:29:03 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:35787 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814Ab2GNO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 10:28:56 -0400
Subject: Re: [PATCH] x86, amd: rename vmmu support capability
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        x86@kernel.org
In-Reply-To: <0ffa7987-66fd-4c8d-85da-9911eee3eeaf@email.android.com>
References: <1342202575.2706.4.camel@offbook>
	 <20120714101951.GB26559@liondog.tnic>
	 <0ffa7987-66fd-4c8d-85da-9911eee3eeaf@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sat, 14 Jul 2012 16:28:51 +0200
Message-ID: <1342276131.2956.6.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 15:38 +0200, H. Peter Anvin wrote:
> Yep, NAK on this one.

Ok, we could at least add a comment when defining X86_FEATURE_NPT.

Thanks,
Davidlohr

> 
> Borislav Petkov <bp@alien8.de> wrote:
> 
> >On Fri, Jul 13, 2012 at 08:02:55PM +0200, Davidlohr Bueso wrote:
> >> From: Davidlohr Bueso <dave@gnu.org>
> >> 
> >> AMD has renamed nested page table technology to rapid virtualization
> >indexing,
> >> reflect this change in the kernel.
> >> 
> >> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> >
> >You know that /proc/cpuinfo is a userspace ABI, right?
> >
> >And are you sure nothing is using that string -
> >"npt" - since it got added almost three years ago by
> >414bb144efa2d2fe16d104d836d0d6b6e9265788?
> >
> >-- 
> >Regards/Gruss,
> >    Boris.
> 


