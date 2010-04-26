Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0DZOr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:47:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab0DZOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:47:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100426232234.5c210566.toshi.okajima@jp.fujitsu.com>
References: <20100426232234.5c210566.toshi.okajima@jp.fujitsu.com> <20100424002319.d68a3819.toshi.okajima@jp.fujitsu.com> <20100423195127.48095127.toshi.okajima@jp.fujitsu.com> <20100422163755.355794e3.toshi.okajima@jp.fujitsu.com> <7894.1271931370@redhat.com> <20100423194547.3135efb8.toshi.okajima@jp.fujitsu.com> <10934.1272022437@redhat.com> <1790.1272037936@redhat.com> 
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][BUG][TAKE2] KEYRINGS: find_keyring_by_name() can gain the freed keyring
Date: Mon, 26 Apr 2010 15:47:48 +0100
Message-ID: <32722.1272293268@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> OK. I understand. So, your patch looks fine to me.
> ---
> Once find_keyring_by_name() returns -ENOKEY, the new user creates a
> new key. So, both the deleting key and the new key may exist.
> Therefore at next find_keyring_by_name() call, we should find the new
> key and ignore the deleting key.
> ---
> 
> Today, I tested your patch and any problem didn't happen.
> So, I rewrote your patch. Here you are:

Thanks.

Note that the vertical lines in the right-hand column of your timeline don't
seem to line up correctly.  Are you editing it in an editor with a
proportional font?

David
