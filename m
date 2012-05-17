Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965704Ab2EQATL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:19:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:23696 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369Ab2EQATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:19:09 -0400
Message-ID: <4FB443FA.1070003@tilera.com>
Date: Wed, 16 May 2012 20:19:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: bad commit in the tile tree
References: <20120517091417.62c65eea7002be18d8af2f34@canb.auug.org.au>
In-Reply-To: <20120517091417.62c65eea7002be18d8af2f34@canb.auug.org.au>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/2012 7:14 PM, Stephen Rothwell wrote:
> Hi Chris,
>
> The top commit on the tile tree has a bad description ("usb hackery" does
> not tell us anything), sprinkles stuff (mainly printk()s) all over the
> generic usb code and is not signed off by anyone ...
>
> I assume it is a debugging patch (or similar) and should *not* be in
> linux-next.
>
> I will use the version of the tile tree from next-20120516 for today
> (unless you update your tree very soon).

Oops :-)  It is debugging hackery.  I committed it to do work on a
different branch, which I then pushed, forgetting that by default I'd push
the linux-next branch as well.  Fixed now.  Sorry!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

