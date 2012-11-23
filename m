Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2KWKvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:51:19 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:53740 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2KWKvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:51:13 -0500
X-IronPort-AV: E=Sophos;i="4.83,306,1352073600"; 
   d="scan'208";a="15970264"
Message-ID: <1353667868.13542.218.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 01/11] kexec: introduce kexec_ops struct
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Fri, 23 Nov 2012 10:51:08 +0000
In-Reply-To: <20121123103726.GB2921@host-192-168-1-59.local.net-space.pl>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
	 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
	 <87lidwtego.fsf@xmission.com>
	 <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
	 <87txshx28b.fsf@xmission.com> <50AE6542.3020302@zytor.com>
	 <50AEBF86.50501@citrix.com>
	 <18e831d4-910d-4f58-8911-1398b96e3a47@email.android.com>
	 <50AED7B8.7040902@citrix.com>
		<50AF55B102000078000AABF3@nat28.tlf.novell.com>
	 <20121123103726.GB2921@host-192-168-1-59.local.net-space.pl>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 10:37 +0000, Daniel Kiper wrote:
> On Fri, Nov 23, 2012 at 09:53:37AM +0000, Jan Beulich wrote:
> > >>> On 23.11.12 at 02:56, Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> > > The crash region (as specified by crashkernel= on the Xen command line)
> > > is isolated from dom0.
> > >[...]
> >
> > But all of this _could_ be done completely independent of the
> > Dom0 kernel's kexec infrastructure (i.e. fully from user space,
> > invoking the necessary hypercalls through the privcmd driver).
> 
> No, this is impossible. kexec/kdump image lives in dom0 kernel memory
> until execution.

Are you sure? I could have sworn they lived in the hypervisor owned
memory set aside by the crashkernel= parameter as Andy suggested.

Ian.

