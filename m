Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2B0WYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:24:35 -0500
Received: from lulu.zabbo.net ([69.168.54.52]:43123 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab2B0WYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:24:33 -0500
Message-ID: <4F4C00D9.6090706@zabbo.net>
Date: Mon, 27 Feb 2012 17:16:57 -0500
From: Zach Brown <zab@zabbo.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 13/22] dio: add __blockdev_direct_IO_bdev()
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <1330377576-3659-14-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1330377576-3659-14-git-send-email-dave.kleikamp@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   	int is_async;			/* is IO async ? */
> +	int should_dirty;		/* should we mark read pages dirty? */

This seems wasteful.  Maybe its time for some bit flags?

- z
