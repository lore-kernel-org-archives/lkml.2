Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab0HEGzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:55:40 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:36625 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795Ab0HEGzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:55:37 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100805062604.GB1546@ucw.cz>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <20100805062604.GB1546@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 16:55:35 +1000
Message-ID: <1280991335.2618.34.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 08:26 +0200, Pavel Machek wrote:
> Why do it in kernel? s2disk should already be faster...

Because LZO support is already there, the patch is straightforward and
not everyone wants to set up userspace tools to hibernate?

If we are relying on s2disk as the only solution, then in-kernel
hibernation should be removed. If not, I don't see why in-kernel
hibernation should suck that much, when we can make it suck less.

-- 
Bojan

