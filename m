Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0HVKXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 06:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0HVKXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 06:23:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C6FE8A5.30309@gnutls.org>
References: <4C6FE8A5.30309@gnutls.org> <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com> <AANLkTinzUuihbS_Znm1rgxPPxiLTXeNx8ySF8LHqU=Jz@mail.gmail.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: dhowells@redhat.com, Kyle Moffett <kyle@moffetthome.net>,
        =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] User-space API definition
Date: Sun, 22 Aug 2010 11:22:47 +0100
Message-ID: <28995.1282472567@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:

> It is not that simple. My understanding of the keyring API is that it
> allows exporting of the keys to user-space and this crypto API
> explicitly prevents that

That's simple.  Don't provide a read() key type operation, then.

David
