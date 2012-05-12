Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2ELJxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 05:53:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2ELJxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 05:53:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1953408.KQLKiNB2bP@donald.sf-tec.de>
References: <1953408.KQLKiNB2bP@donald.sf-tec.de> <3154414.psmJh6J2U2@donald.sf-tec.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: dhowells@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] use linux/bitops.h instead of linux/log2.h to get fls()
Date: Sat, 12 May 2012 10:53:20 +0100
Message-ID: <17259.1336816400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> -#include <linux/log2.h>

That is still required as get_order() uses ilog2().

David
