Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3ABP1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:27:37 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:29803 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3ABP1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:27:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,396,1355097600"; 
   d="scan'208";a="416044"
Message-ID: <1357140452.5668.69.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Date: Wed, 2 Jan 2013 15:27:32 +0000
In-Reply-To: <50DC58C4.3000307@citrix.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	 <50DBC856.6030208@zytor.com>
	 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	 <50DC58C4.3000307@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 14:18 +0000, Andrew Cooper wrote:
> Many cloud customers and service providers want the ability for a VM
> administrator to be able to load a kdump/kexec kernel within a
> domain[1].  This allows the VM administrator to take more proactive
> steps to isolate the cause of a crash, the state of which is most likely
> discarded while tearing down the domain.  The result being that as far
> as Xen is concerned, the domain is still alive, while the kdump
> kernel/environment can work its usual magic.  I am not aware of any
> feature like this existing in the past.

I have a feeling that some versions of the classic-Xen port supported
domU kexec as well. Certainly there was some work on that back in 2005,
although I can't see much evidence that that attempt ever went anywhere
so maybe I'm imagining things.

It's possible that I'm confusing domU kexec support with support for
domU kexec in some dom0 kernels. That was/is used to support "kexec"
from a PV bootloader into the real kernel (which looks to the host a lot
like a domU kexec would).

Ian.

