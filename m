Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2ARPOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:14:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647Ab2ARPOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:14:12 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CALLzPKb4EycNZAd_80x-+p-iJ94CHerngOFZZmdrLpoJ+bYRMQ@mail.gmail.com>
References: <CALLzPKb4EycNZAd_80x-+p-iJ94CHerngOFZZmdrLpoJ+bYRMQ@mail.gmail.com> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184406.21874.65285.stgit@warthog.procyon.org.uk> <CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com> <26123.1326889583@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver #3]
Date: Wed, 18 Jan 2012 15:13:44 +0000
Message-ID: <29789.1326899624@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> Yes. it is clear...
> Would it be possible to have pass data (uncompleted) hash?

Yes, provided it's not finalised.  Also, with the current code it would have
to be a shash, but I think I should be able to support the passing in of an
async hash by exporting the state from that and importing the state into a
shash using the crypto layer export and import functions.

David
