Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab1LSR7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:59:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1LSR7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:59:49 -0500
Date: Mon, 19 Dec 2011 23:29:21 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111219175921.GA4668@amit-x200.redhat.com>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <20111208113422.GA27919@amit-x200.redhat.com>
 <4EE9E023.4000904@redhat.com>
 <20111219125217.GC3139@amit-x200.redhat.com>
 <4EEF3538.9060808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF3538.9060808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 19 Dec 2011 [14:59:36], Avi Kivity wrote:
> On 12/19/2011 02:52 PM, Amit Shah wrote:

(snip)

> > S4 needs some treatment, though, as resume after s4 doesn't work with
> > kvmclock enabled.  I didn't realise this series was only handling the
> > soft lockup case.
> >
> 
> What's the issue there?

Not sure yet; after resume, the VM freezes while bringing the 2nd vcpu
up.  Maybe it's just sitting there spinning, maybe the delta needs
adjusting.  Haven't poked at it yet.

		Amit
