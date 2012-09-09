Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2IIJzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:55:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2IIJy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:54:57 -0400
Message-ID: <504C6761.6010904@kernel.dk>
Date: Sun, 09 Sep 2012 11:54:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Dave Reisner <dreisner@archlinux.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] block: reject invalid queue attribute values
References: <1347119745-7044-1-git-send-email-dreisner@archlinux.org>
In-Reply-To: <1347119745-7044-1-git-send-email-dreisner@archlinux.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-08 17:55, Dave Reisner wrote:
> Instead of using simple_strtoul which "converts" invalid numbers to 0,
> use strict_strtoul and perform error checking to ensure that userspace
> passes us a valid unsigned long. This addresses problems with functions
> such as writev, which might want to write a trailing newline -- the
> newline should rightfully be rejected, but the value preceeding it
> should be preserved.

Thanks, applied to for-3.7/core.

-- 
Jens Axboe

