Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3ADOke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:40:34 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43758 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3ADOkc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Fri, 4 Jan 2013 09:40:32 -0500
Message-Id: <50E6F81D02000078000B3245@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 04 Jan 2013 14:41:17 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <50DBC856.6030208@zytor.com>
 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
 <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
 <50E41973.9050705@citrix.com>
 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
In-Reply-To: <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.01.13 at 15:22, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> On Wed, Jan 02, 2013 at 11:26:43AM +0000, Andrew Cooper wrote:
>> /sbin/kexec can load the "Xen" crash kernel itself by issuing
>> hypercalls using /dev/xen/privcmd.  This would remove the need for
>> the dom0 kernel to distinguish between loading a crash kernel for
>> itself and loading a kernel for Xen.
>>
>> Or is this just a silly idea complicating the matter?
> 
> This is impossible with current Xen kexec/kdump interface.

Why?

> It should be changed to do that. However, I suppose that
> Xen community would not be interested in such changes.

And again - why?

Jan

