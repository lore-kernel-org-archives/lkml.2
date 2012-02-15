Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2BORK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:10:26 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:22170 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2BORKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:10:25 -0500
Message-ID: <4F3BE6FF.9010408@tilera.com>
Date: Wed, 15 Feb 2012 12:10:23 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/12] arch/tile: remove references to cpu_*_map.
References: <1329281884.20453.rusty@rustcorp.com.au>
In-Reply-To: <1329281884.20453.rusty@rustcorp.com.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/2012 11:58 PM, Rusty Russell wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> This has been obsolescent for a while; time for the final push.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/kernel/setup.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

The comment change in arch/tile/kernel/setup.c in patch 11/12 is fine too.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

