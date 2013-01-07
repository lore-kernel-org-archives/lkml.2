Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3AGNts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:49:48 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:4665 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3AGNtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:49:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,424,1355097600"; 
   d="scan'208";a="488403"
Message-ID: <1357566584.7989.73.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Jan Beulich" <JBeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Date: Mon, 7 Jan 2013 13:49:44 +0000
In-Reply-To: <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	 <50DBC856.6030208@zytor.com>
	 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
	 <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
	 <50E41973.9050705@citrix.com>
	 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
	 <50E6F81D02000078000B3245@nat28.tlf.novell.com>
	 <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
	 <20130104191146.GC6721@phenom.dumpdata.com>
	 <20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 12:34 +0000, Daniel Kiper wrote:
> I think that new kexec hypercall function should mimics kexec syscall.

We want to have an interface can be used by non-Linux domains (both dom0
and domU) as well though, so please bear this in mind.

Historically we've not always been good at this when the hypercall
interface is strongly tied to a particular guest implementation (in some
sense this is the problem with the current kexec hypercall).

Also what makes for a good syscall interface does not necessarily make
for a good hypercall interface.

Ian.

