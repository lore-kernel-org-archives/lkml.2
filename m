Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1B1OTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:19:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1B1OTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:19:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <28535.1298648979@redhat.com>
References: <28535.1298648979@redhat.com> <20110215153856.10e19fbf@kryten>
To: Anton Blanchard <anton@au1.ibm.com>
Cc: dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: RxRPC: Fix v1 keys
Date: Mon, 28 Feb 2011 14:19:35 +0000
Message-ID: <31510.1298902775@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Anton Blanchard <anton@au1.ibm.com> wrote:
> 
> > commit 339412841d7 (RxRPC: Allow key payloads to be passed in XDR form)
> > broke klog for me. I notice the v1 key struct had a kif_version field
> > added:
> 
> Hmmm...  I published a new version of klog at the same time, so just removing
> kif_version will break that:-/
> 
> I'll have to come up with a way of detecting which you're doing.  But first,
> I need to attempt to resuscitate my OpenAFS server.

You're right.  Patch signed off and sent on.

David
