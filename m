Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2KUMMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2KUMMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:12:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121121112609.5567.70258.stgit@warthog.procyon.org.uk>
References: <20121121112609.5567.70258.stgit@warthog.procyon.org.uk>
To: torvalds@osdl.org, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, Chun-Yi Lee <jlee@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sign-file: fix the perl warning message when extracting ASN.1
Date: Wed, 21 Nov 2012 11:40:04 +0000
Message-ID: <5904.1353498004@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> There have the following warning message when running modules install for sign ko files:
> 
> # make modules_install
> ...
>   INSTALL drivers/input/touchscreen/pcap_ts.ko
> Found = in conditional, should be == at scripts/sign-file line 164.
> Found = in conditional, should be == at scripts/sign-file line 161.
> Found = in conditional, should be == at scripts/sign-file line 159.
> 
> This patch change replace '=' by '==' in elsif conditions for avoid the above warning messages.
> 
> Signed-off-by: Chun-Yi Lee <jlee@suse.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Hmmm...  It seems that stgit-0.16 no longer puts authorship information into
the mail message.  This was actually authored by Chun-Yi Lee, not myself.

David
