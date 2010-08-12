Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab0HLPYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab0HLPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:24:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
References: <AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com> <20100812131741.f3a800d7.sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Thu, 12 Aug 2010 16:24:37 +0100
Message-ID: <6410.1281626677@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> net/dns_resolver/Kconfig config DNS_RESOLVER "depends on NET && KEYS"
> so ... CONFIG_KEYS should be set ....

Perhaps it needs to select CONFIG_KEYS instead?

David
