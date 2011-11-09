Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1KICcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 21:32:20 -0500
Received: from smtp24.mail.ru ([94.100.176.177]:35610 "EHLO smtp24.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1KICcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 21:32:18 -0500
Date: Wed, 9 Nov 2011 10:32:07 +0800
From: Daniil Stolnikov <danila.st@mail.ru>
Reply-To: Daniil Stolnikov <danila.st@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <552673196.20111109103207@mail.ru>
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        <linux-crypto@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <davem@davemloft.net>,
        <adobriyan@gmail.com>, <peter.p.waskiewicz.jr@intel.com>,
        <herbert@gondor.hengli.com.au>
Subject: Re: Add IPSec IP Range in Linux kernel
In-Reply-To: <20111108.204253.891598837549584662.davem@davemloft.net>
References: <CACVxJT887ATwt97iw7mPEkH+KXgy1WbsP_aUB_X-8uLQ+6YsLQ@mail.gmail.com> <20111108.121620.2044664919065812135.davem@davemloft.net> <1289495586.20111109093607@mail.ru> <20111108.204253.891598837549584662.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Like I said, if you want address ranges, ask the userland IPSEC daemon
> authors to synthesize it.

In this letter, the mailing list http://marc.info/?l=strongswan-users&m=130613736616488&w=4 strongswan-users say that their product has support for IP ranges, but the stack of Linux is based on network masks. So I do not understand how this would work without the support at the kernel level? How will coordination of policies?

