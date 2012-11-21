Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab2KUVK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 16:10:29 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:42073 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964850Ab2KUVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 16:10:28 -0500
Date: Wed, 21 Nov 2012 13:10:18 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Joe Perches <joe@perches.com>
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        George Zhang <georgezhang@vmware.com>
Message-ID: <904751617.29421555.1353532218495.JavaMail.root@vmware.com>
In-Reply-To: <1353531886.24807.43.camel@joe-AO722>
Subject: Re: [Pv-drivers] [PATCH 01/12] VMCI: context implementation.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC23 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> Just some trivial notes.

Thanks for taking a look!

> > +		pr_warn("Failed to allocate memory for VMCI context.\n");
> 
> OOM logging messages aren't necessary as alloc failures
> are already logged with a stack trace.

Noted, we'll remove all such occurrences.

> Maybe just use
> 	struct vmci_event_msg e_msg;
> 	struct vmci_event_payld_ctx ev_payload;
> and change the addressing or use a cast as appropriate?

It does seem inelegant, we'll take a look.

> You also have some inconsistency in whether or not your
> logging messages use a terminating period.  I suggest
> you just delete all the periods.
> 	s/\.\\n"/\\n"/g

Gah, that's ugly.  We'll remove all of them as you suggest.

Thanks!
- Andy
