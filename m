Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3ACJfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:35:04 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:59103 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3ACJe7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 3 Jan 2013 04:34:59 -0500
Message-Id: <50E55ECF02000078000B2A13@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 03 Jan 2013 09:34:55 +0000
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
In-Reply-To: <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.12.12 at 03:18, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Some implementations (e.g. Xen PVOPS) could not use part of identity page 
> table
> to construct transition page table. It means that they require separate 
> PUDs,
> PMDs and PTEs for virtual and physical (identity) mapping. To satisfy that
> requirement add extra pointer to PGD, PUD, PMD and PTE and align existing 
> code.

So you keep posting this despite it having got pointed out on each
earlier submission that this is unnecessary, proven by the fact that
the non-pvops Xen kernels can get away without it. Why?

Jan

