Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2GNNd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:33:59 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:42226 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907Ab2GNNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:33:57 -0400
X-Greylist: delayed 70258 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2012 09:33:57 EDT
Subject: Re: [PATCH] x86, amd: rename vmmu support capability
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>,
        x86@kernel.org
In-Reply-To: <20120714101951.GB26559@liondog.tnic>
References: <1342202575.2706.4.camel@offbook>
	 <20120714101951.GB26559@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Sat, 14 Jul 2012 15:33:52 +0200
Message-ID: <1342272832.2956.5.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-14 at 12:19 +0200, Borislav Petkov wrote:
> On Fri, Jul 13, 2012 at 08:02:55PM +0200, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > AMD has renamed nested page table technology to rapid virtualization indexing,
> > reflect this change in the kernel.
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> 
> You know that /proc/cpuinfo is a userspace ABI, right?

Yes.

> 
> And are you sure nothing is using that string -
> "npt" - since it got added almost three years ago by
> 414bb144efa2d2fe16d104d836d0d6b6e9265788?

AFAIK no, it's not being used - that doesn't mean, of course, that there
are no users.

Thanks,
Davidlohr

