Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1CXUQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:16:13 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:52320 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab1CXUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:16:08 -0400
Date: Thu, 24 Mar 2011 16:16:02 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/21]arch:arm:mach Remove extra comma.
Message-ID: <20110324201602.GA28979@elliptictech.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-24 12:26 -0700, Justin P. Mattock wrote:
> The patch below removes an extra comma from various parts 
> of the kernel. Please have a look when you have time, and let
> me know if its legit or not. 

You say here that you are removing commas...

> diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
[...]
> -	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
> +	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));

...yet you are actually removing semicolons.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
