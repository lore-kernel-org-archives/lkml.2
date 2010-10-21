Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0JUU1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:27:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60337 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab0JUU1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:27:53 -0400
Message-ID: <4CC0A204.4060403@zytor.com>
Date: Thu, 21 Oct 2010 13:26:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        "jeremy@xensource.com" <jeremy@xensource.com>
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>	 <1286816964.1372.2.camel@ank32.eng.vmware.com>	 <m1lj64ppri.fsf@fess.ebiederm.org>	 <1286826083.1372.15.camel@ank32.eng.vmware.com>	 <20101011213901.GR12743@redhat.com> <m1hbgs5qkc.fsf@fess.ebiederm.org>	 <20101012221717.GA27478@redhat.com>	 <1286929430.15658.30.camel@ank32.eng.vmware.com> <1287688156.27008.13.camel@ank32.eng.vmware.com>
In-Reply-To: <1287688156.27008.13.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 12:09 PM, Alok Kataria wrote:
> 
> I don't think this patch was picked up for tip, now that the 2.6.37
> merge window is open can you please pick this up push it upstream.
> This patch fixes a legitimate regression, which was introduced during
> 2.6.30, by commit id 4ef702c10b5df18ab04921fc252c26421d4d6c75.
> 

It probably would have helped if the patch had had a proper patch header
and so on, and *in particular* not buried in a tree with [RFC PATCH].
RFC strongly implies that the patch is intended as a base for
discussion, and is explicitly not intended to be committed.

	-hpa
