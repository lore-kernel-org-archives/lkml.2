Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1KICnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 21:43:20 -0500
Received: from smtp5.mail.ru ([94.100.176.132]:48209 "EHLO smtp5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KICnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 21:43:17 -0500
Date: Wed, 9 Nov 2011 10:43:09 +0800
From: Daniil Stolnikov <danila.st@mail.ru>
Reply-To: Daniil Stolnikov <danila.st@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1683717478.20111109104309@mail.ru>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        <linux-crypto@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <davem@davemloft.net>,
        <adobriyan@gmail.com>, <peter.p.waskiewicz.jr@intel.com>,
        <davem@davemloft.net>
Subject: Re: Add IPSec IP Range in Linux kernel
In-Reply-To: <20111109015406.GA10800@gondor.apana.org.au>
References: <20111108.204253.891598837549584662.davem@davemloft.net> <20111109015406.GA10800@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Alternatively you can do this with marking and use netfilter
> to set the mark.

> Cheers,

We focus on connections to devices zywall. If you choose to zywall IP range as the remote side will not harmonize policies. The connection is not established. And this alternative makes no sense.

Regards
Daniil Stolnikov

