Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2I0CJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:09:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39551 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab2I0CJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:09:44 -0400
Message-ID: <1348711443.17807.12.camel@falcor>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Date: Wed, 26 Sep 2012 22:04:03 -0400
In-Reply-To: <87ehlp30pd.fsf@rustcorp.com.au>
References: <5555.1348531649@warthog.procyon.org.uk>
	 <87ehlp30pd.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12092702-8974-0000-0000-00000E7D1800
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00177609; UDB=6.00040218; UTC=2012-09-27
 02:09:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 13:16 +0930, Rusty Russell wrote:
> David Howells <dhowells@redhat.com> writes:
> > The module signing patches provide:
> >
> >  - Some fixes to Rusty's patch.  Also an additional patch to extend the policy
> >    handling for modules signed with an unknown key and to handle FIPS mode.
> 
> Ok, I merged some of this (after our previous accidentally-off-list
> discussion).

Rusty, have you pushed this branch out yet?

thanks,

Mimi

