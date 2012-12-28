Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2L1M7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 07:59:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45419 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab2L1M7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 07:59:30 -0500
Date: Fri, 28 Dec 2012 13:59:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: hpa@zytor.com, kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, ebiederm@xmission.com,
        maxim.uvarov@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        mingo@redhat.com, x86@kernel.org,
        virtualization@lists.linux-foundation.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] x86/kexec: Add extra pointers to transition
 page table PGD, PUD, PMD and PTE
Message-ID: <20121228125926.GA13224@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Kiper <daniel.kiper@oracle.com>, hpa@zytor.com,
	kexec@lists.infradead.org, xen-devel@lists.xensource.com,
	konrad.wilk@oracle.com, tglx@linutronix.de, ebiederm@xmission.com,
	maxim.uvarov@oracle.com, andrew.cooper3@citrix.com,
	jbeulich@suse.com, mingo@redhat.com, x86@kernel.org,
	virtualization@lists.linux-foundation.org, vgoyal@redhat.com,
	linux-kernel@vger.kernel.org
References: <71b94237-c365-47ba-8d75-5ee1d8caee73@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <71b94237-c365-47ba-8d75-5ee1d8caee73@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 03:19:24PM -0800, Daniel Kiper wrote:
> > Hmm... this code is being redone at the moment... this might conflict.
> 
> Is this available somewhere? May I have a look at it?

http://marc.info/?l=linux-kernel&m=135581534620383

The for-x86-boot-v7 and -v8 branches.

HTH.

-- 
Regards/Gruss,
Boris.
