Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab0KPUn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:43:58 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47051 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab0KPUn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:43:57 -0500
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <26645.1289929851@redhat.com>
References: <1289918320.3188.16.camel@localhost.localdomain>
	 <1289849751.3027.17.camel@localhost.localdomain>
	 <1289694826.3257.82.camel@localhost.localdomain>
	 <1289595738.2731.80.camel@localhost.localdomain>
	 <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <26689.1289591135@redhat.com> <27900.1289597013@redhat.com>
	 <8268.1289837934@redhat.com> <23151.1289916524@redhat.com>
	 <26645.1289929851@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 15:43:53 -0500
Message-ID: <1289940233.2627.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 17:50 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > I actually like keyctl requiring 'trusted:' or 'user:'.  Forcing the
> > user to indicate which type of key they want, is actually good - no
> > misunderstandings.
> 
> You still need to prefix the description of a user-defined key so that you
> don't collide with other people who're also using user-defined keys for random things.

Although I previously agreed to this change, I'm really not convinced it
is necessary.  encrypted keys don't create new trusted or user keys,
they only use existing keys to encrypt/decrypt encrypted
keys(instantiate,read).  Key names, user or otherwise, should be left up
to the person creating them.

thanks,

Mimi

