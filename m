Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab0JUVKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:10:08 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52190 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757954Ab0JUVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:10:06 -0400
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <4CC0A204.4060403@zytor.com>
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	 <1286816964.1372.2.camel@ank32.eng.vmware.com>
	 <m1lj64ppri.fsf@fess.ebiederm.org>
	 <1286826083.1372.15.camel@ank32.eng.vmware.com>
	 <20101011213901.GR12743@redhat.com> <m1hbgs5qkc.fsf@fess.ebiederm.org>
	 <20101012221717.GA27478@redhat.com>
	 <1286929430.15658.30.camel@ank32.eng.vmware.com>
	 <1287688156.27008.13.camel@ank32.eng.vmware.com>
	 <4CC0A204.4060403@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 21 Oct 2010 14:10:06 -0700
Message-Id: <1287695406.27008.31.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2010-10-21 at 13:26 -0700, H. Peter Anvin wrote:
> On 10/21/2010 12:09 PM, Alok Kataria wrote:
> > 
> > I don't think this patch was picked up for tip, now that the 2.6.37
> > merge window is open can you please pick this up push it upstream.
> > This patch fixes a legitimate regression, which was introduced during
> > 2.6.30, by commit id 4ef702c10b5df18ab04921fc252c26421d4d6c75.
> > 
> 
> It probably would have helped if the patch had had a proper patch header
> and so on, and *in particular* not buried in a tree with [RFC PATCH].
> RFC strongly implies that the patch is intended as a base for
> discussion, and is explicitly not intended to be committed.

I see, I have sent another mail with the patch.

Thanks,
Alok
> 
> 	-hpa

