Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab0FUUol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:44:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52950
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758385Ab0FUUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:44:40 -0400
Date: Mon, 21 Jun 2010 13:44:52 -0700 (PDT)
Message-Id: <20100621.134452.39190078.davem@davemloft.net>
To: jslaby@suse.cz
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] CRYPTO: ablkcipher, avoid NULL dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1277132483-14172-1-git-send-email-jslaby@suse.cz>
References: <1277132483-14172-1-git-send-email-jslaby@suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 21 Jun 2010 17:01:23 +0200

> Stanse found a potential NULL dereference in ablkcipher_next_slow.
> Even though kmalloc fails, its retval is dereferenced later. Return
> from that function properly earlier.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Thanks for fixing this:

Acked-by: David S. Miller <davem@davemloft.net>
