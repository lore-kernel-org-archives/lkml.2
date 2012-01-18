Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab2ARUAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:00:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757901Ab2ARUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:00:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALLzPKZ8voNPoyfTznq+_gPThbW6rqdGKLBztZ8qkesM2qtziQ@mail.gmail.com>
References: <CALLzPKZ8voNPoyfTznq+_gPThbW6rqdGKLBztZ8qkesM2qtziQ@mail.gmail.com> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184406.21874.65285.stgit@warthog.procyon.org.uk> <CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com> <26123.1326889583@redhat.com> <CALLzPKb4EycNZAd_80x-+p-iJ94CHerngOFZZmdrLpoJ+bYRMQ@mail.gmail.com> <29789.1326899624@redhat.com> 
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver #3]
Date: Wed, 18 Jan 2012 19:59:38 +0000
Message-ID: <31888.1326916778@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> I thought about export/import.
> But I think export/Import is hash driver implementation specific...
> Cannot use ahash state for shash...

Yeah...  I'll have to consult Herbert Xu about that.

> As you said in repose to later patch, you could provide some function  to
> build a final metadata buffer out of signature to finalize the hash...

That might be the only way to do it.

David
