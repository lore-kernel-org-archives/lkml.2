Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0JTVRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:17:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715Ab0JTVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:17:39 -0400
Date: Wed, 20 Oct 2010 14:16:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Fix kfifo_alloc() to return a signed int value
Message-Id: <20101020141648.c170e3e8.akpm@linux-foundation.org>
In-Reply-To: <1287605544-21270-1-git-send-email-stefani@seibold.net>
References: <1287605544-21270-1-git-send-email-stefani@seibold.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 22:12:23 +0200
stefani@seibold.net wrote:

> This patch adds a new __kfifo_int_must_check_helper() helper function,
> which is needed for kfifo_alloc() to return the right signed integer
> value.
> 
> The origin __kfifo_must_check_helper() helper was renamed into
> __kfifo_uint_must_check_helper() to show the sign which is expected and
> returned.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
>  include/linux/kfifo.h |   28 +++++++++++++++++-----------

We're probably just days away from 2.6.36.  I went with the
safe-and-stupid fix.  I'll queue this patch for 2.6.37-rc1.
