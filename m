Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab1LPD5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 22:57:06 -0500
Received: from ozlabs.org ([203.10.76.45]:47030 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab1LPD5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 22:57:03 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
In-Reply-To: <24260.1323908071@redhat.com>
References: <87obvdtdwz.fsf@rustcorp.com.au> <87ty56taup.fsf@rustcorp.com.au> <87obvfogc6.fsf@rustcorp.com.au> <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <30007.1323526114@redhat.com> <26644.1323652900@redhat.com> <21605.1323706287@redhat.com>  <24260.1323908071@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 16 Dec 2011 11:11:23 +1030
Message-ID: <8762hhqrf0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 00:14:31 +0000, David Howells <dhowells@redhat.com> wrote:
> Rusty Russell <rusty@ozlabs.org> wrote:
> 
> > > > We can have false positives, but at worst that make us report EINVAL
> > > > (bad signature) instead of ENOENT (no signature).
> > > 
> > > EKEYREJECTED please; that way it's the same as RHEL does now.
> > 
> > OK, sure (who knew that was there?).

Oh yes, I read these, but I didn't appreciate that those errnos had
existed for over 6 years.

Cheers,
Rusty.
