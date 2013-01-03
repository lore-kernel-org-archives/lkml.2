Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3ACJbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:31:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:48906 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3ACJba convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 3 Jan 2013 04:31:30 -0500
Message-Id: <50E55DFD02000078000B2A10@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 03 Jan 2013 09:31:25 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <50DBC856.6030208@zytor.com>
 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
 <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
 <50E41973.9050705@citrix.com>
In-Reply-To: <50E41973.9050705@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.01.13 at 12:26, Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> On 27/12/12 18:02, Eric W. Biederman wrote:
>> It probably make sense to split them apart a little even.
> 
> Thinking about this split, there might be a way to simply it even more.
> 
> /sbin/kexec can load the "Xen" crash kernel itself by issuing hypercalls 
> using /dev/xen/privcmd.  This would remove the need for the dom0 kernel 
> to distinguish between loading a crash kernel for itself and loading a 
> kernel for Xen.
> 
> Or is this just a silly idea complicating the matter?

I don't think so (and suggested that before as a response to an
earlier submission of this patch set), and it would make most of
the discussion here mute.

Jan

