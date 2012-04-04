Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2DDXvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:51:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40369 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753899Ab2DDXvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:51:21 -0400
Message-ID: <1333583480.23520.37.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Date: Wed, 04 Apr 2012 16:51:20 -0700
In-Reply-To: <1333569554.864.3.camel@mop>
References: <1333569554.864.3.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 21:59 +0200, Kay Sievers wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk: support structured and multi-facility log messages
[]
> This patch extends printk() to be able to attach arbitrary key/value
> pairs to logged messages,

How does it do that?

[]

> - Records consume almost the same amount, sometimes less memory than
>   the traditional byte stream buffer (if printk_time is enabled). The record
>   header is 16 bytes long, plus some padding bytes at the end if needed.
>   The byte-stream buffer needed 3 chars for the syslog prefix, 15 char for
>   the timestamp and a newline.

I suggest using lzo on the string portion.


