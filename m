Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3ADONX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:13:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36784 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3ADONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:13:21 -0500
Date: Fri, 4 Jan 2013 15:12:32 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Borislav Petkov <bp@alien8.de>, hpa@zytor.com, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        tglx@linutronix.de, ebiederm@xmission.com, maxim.uvarov@oracle.com,
        andrew.cooper3@citrix.com, jbeulich@suse.com, mingo@redhat.com,
        x86@kernel.org, virtualization@lists.linux-foundation.org,
        vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] x86/kexec: Add extra pointers to transition
 page table PGD, PUD, PMD and PTE
Message-ID: <20130104141232.GB3346@host-192-168-1-59.local.net-space.pl>
References: <71b94237-c365-47ba-8d75-5ee1d8caee73@default>
 <20121228125926.GA13224@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228125926.GA13224@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 01:59:27PM +0100, Borislav Petkov wrote:
> On Thu, Dec 27, 2012 at 03:19:24PM -0800, Daniel Kiper wrote:
> > > Hmm... this code is being redone at the moment... this might conflict.
> >
> > Is this available somewhere? May I have a look at it?
>
> http://marc.info/?l=linux-kernel&m=135581534620383
>
> The for-x86-boot-v7 and -v8 branches.
>
> HTH.

Thanks.

Daniel
