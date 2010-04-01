Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0DATSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:18:55 -0400
Received: from mail.perches.com ([173.55.12.10]:1320 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633Ab0DATSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:18:49 -0400
Date: Thu, 1 Apr 2010 11:18:37 -0800 (PST)
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Timo Witte <timo.witte@googlemail.com>, <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH] /fs/cifs HEAD
In-Reply-To: <20100401115620.41821f7d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.30.1004011107001.355-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Andrew Morton wrote:
> -		cERROR(1, ("%s: unable to resolve: %s", __func__, name));
> +		cERROR(1, ("%s: unable to resolve: %s have you "
> +			"installed /sbin/request-key ?", __func__, name));

It might be better as a single line, but given the desire to break
it up for 80 colums, maybe make it a bit more grammatically correct too:

		cERROR(1, ("%s: unable to resolve: '%s'.  "
			   "Have you installed /sbin/request-key?",
			   __func__, name));

