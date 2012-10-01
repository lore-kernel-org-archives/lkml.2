Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2JANCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:02:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35684 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2JANCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:02:07 -0400
Date: Mon, 1 Oct 2012 15:01:51 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: andrew.cooper3@citrix.com, xen-devel <xen-devel@lists.xen.org>,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] x86/kexec: Add extra pointers to transition page
 table PGD, PUD, PMD and PTE
Message-ID: <20121001130151.GC2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <50657462020000780009E64A@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50657462020000780009E64A@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 08:56:50AM +0100, Jan Beulich wrote:
> >>> On 27.09.12 at 20:06, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > Some implementations (e.g. Xen PVOPS) could not use part of identity page
> > table to construct transition page table. It means that they require separate
> > PUDs, PMDs and PTEs for virtual and physical (identity) mapping. To satisfy that
> > requirement add extra pointer to PGD, PUD, PMD and PTE and align existing
> > code.
>
> I'm puzzled by this - why would you need to reintroduce what had
> been dropped a long time ago, when the forward ported kernels
> don't need it? Xen itself doesn't need the extra entries, their
> presence is purely a requirement of the specific kernel
> implementation afaict.

Hmmm... I will try to optimize that a bit.

Daniel
