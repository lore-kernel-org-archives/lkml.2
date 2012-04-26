Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab2DZQ4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:56:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62362 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab2DZQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:56:42 -0400
Message-ID: <4F997058.6070509@landley.net>
Date: Thu, 26 Apr 2012 10:57:12 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alexander Graf <agraf@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KVM <kvm@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Xen <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH RFC V6 5/5] Documentation/kvm : Add documentation on Hypercalls
 and features used for PV spinlock
References: <20120423095937.30893.14776.sendpatchset@codeblue.in.ibm.com> <20120423100034.30893.81866.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120423100034.30893.81866.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:00 AM, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 
...
> --- /dev/null
> +++ b/Documentation/virtual/kvm/hypercalls.txt
> @@ -0,0 +1,59 @@
> +KVM Hypercalls Documentation
> +===========================
> +Template for documentation is
> +The documenenation for hypercalls should inlcude

What does the line about templates mean/

documenenation? inlcude?

> +1. Hypercall name, value.
> +2. Architecture(s)
> +3. status (deprecated, obsolete, active)
> +4. Purpose
> +
> +
> +1. KVM_HC_VAPIC_POLL_IRQ
> +------------------------
> +value: 1
> +Architecture: x86
> +Purpose:

Purpose: none.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
