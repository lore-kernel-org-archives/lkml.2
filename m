Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3ABOnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:43:49 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:13090 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3ABOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:43:45 -0500
X-IronPort-AV: E=Sophos;i="4.84,396,1355097600"; 
   d="scan'208";a="414994"
Message-ID: <1357137817.5668.54.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v3 06/11] x86/xen: Add i386 kexec/kdump
 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Date: Wed, 2 Jan 2013 14:43:37 +0000
In-Reply-To: <87han6n9wh.fsf@xmission.com>
References: <5698071f-c96c-4891-81d6-a77c4e3b77c2@default>
	 <50DCDBD3.1020703@zytor.com> <87han6n9wh.fsf@xmission.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 03:16 +0000, Eric W. Biederman wrote:
> Hasn't 32bit dom0 been retired?

The 32 bit hypervisor has been but 32 bit (PAE) guests (which includes
dom0) are still supported on top of a 64 bit hypervisor. There are no
plans to remove that support.

Ian

