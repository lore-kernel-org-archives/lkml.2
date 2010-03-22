Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0CVNFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:05:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVNFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:05:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100322125626.GM21571@bicker>
References: <20100322125626.GM21571@bicker> <20100320111938.GT5331@bicker> <28809.1269259520@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: dhowells@redhat.com, kernel-janitors@vger.kernel.org,
       linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] afs: potential null dereference
Date: Mon, 22 Mar 2010 13:05:24 +0000
Message-ID: <12814.1269263124@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> I was concerned about the dereference here:
> 
> +       if (xpermits)
> +               memcpy(permits->permits, xpermits->permits,
>                                          ^^^^^^^^^^^^^^^^^
> +                       count * sizeof(struct afs_permit));

That's a good point - in which case your patch should definitely go in.

David
