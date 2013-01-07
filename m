Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3AGJs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:48:28 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52843 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3AGJs1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Mon, 7 Jan 2013 04:48:27 -0500
Message-Id: <50EAA7F402000078000B34C3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 07 Jan 2013 09:48:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <kexec@lists.infradead.org>,
        <virtualization@lists.linux-foundation.org>,
        "xen-devel" <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <maxim.uvarov@oracle.com>, <mingo@redhat.com>, <vgoyal@redhat.com>,
        <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 02/11] x86/kexec: Add extra pointers to
 transition page table PGD, PUD, PMD and PTE
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com>
 <50E55ECF02000078000B2A13@nat28.tlf.novell.com>
 <20130104151542.GD3346@host-192-168-1-59.local.net-space.pl>
 <50E70D8002000078000B336D@nat28.tlf.novell.com>
 <20130104172538.GC3472@host-192-168-1-59.local.net-space.pl>
In-Reply-To: <20130104172538.GC3472@host-192-168-1-59.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.01.13 at 18:25, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Right, so where is virtual mapping of control page established?
> I could not find relevant code in SLES kernel which does that.

In the hypervisor (xen/arch/x86/machine_kexec.c:machine_kexec_load()).
xen/arch/x86/machine_kexec.c:machine_kexec() then simply uses
image->page_list[1].

Jan

