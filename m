Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1FGNbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab1FGNbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:31:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1307443181-22278-6-git-send-email-me@akshayjoshi.com>
References: <1307443181-22278-6-git-send-email-me@akshayjoshi.com> <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: dhowells@redhat.com, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Kernel: fix spaces with respect to the coding style in sys.c.
Date: Tue, 07 Jun 2011 14:30:46 +0100
Message-ID: <23758.1307453446@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akshay Joshi <me@akshayjoshi.com> wrote:

>  /*
>   *	Back compatibility for getrlimit. Needed for some apps.
>   */
> - 
> +
>  SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,

You could just have deleted that blank line there.

Apart from that, feel free to add my Acked-by to the three patches you cc'd me
on.

David
