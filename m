Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2L0XXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:23:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19633 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2L0XXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:23:30 -0500
MIME-Version: 1.0
Message-ID: <5698071f-c96c-4891-81d6-a77c4e3b77c2@default>
Date: Thu, 27 Dec 2012 15:23:02 -0800 (PST)
From: Daniel Kiper <daniel.kiper@oracle.com>
To: <hpa@zytor.com>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <ebiederm@xmission.com>, <maxim.uvarov@oracle.com>,
        <andrew.cooper3@citrix.com>, <jbeulich@suse.com>, <mingo@redhat.com>,
        <x86@kernel.org>, <virtualization@lists.linux-foundation.org>,
        <vgoyal@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 06/11] x86/xen: Add i386 kexec/kdump implementation
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/26/2012 06:18 PM, Daniel Kiper wrote:
> > Add i386 kexec/kdump implementation.
> >
> > v2 - suggestions/fixes:
> >     - allocate transition page table pages below 4 GiB
> >       (suggested by Jan Beulich).
>
> Why?

Sadly all addresses are passed via unsigned long
variable to kexec hypercall.

Daniel
