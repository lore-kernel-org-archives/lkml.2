Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0IWUrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:47:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2306 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab0IWUrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:47:07 -0400
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
From: Joe Perches <joe@perches.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100923133132.3faae5b3@jbarnes-desktop>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>
	 <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop>
	 <4C784650.2030200@cesarb.net> <1282962104.1946.179.camel@Joe-Laptop>
	 <20100923133132.3faae5b3@jbarnes-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 13:47:05 -0700
Message-ID: <1285274825.25928.19.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 13:31 -0700, Jesse Barnes wrote:
> I think the programmed limits are valid if they're nonzero and less
> than one of the available default limits.  If they're not valid, we
> should just use the default values.  I was thinking something like the
> below for MCP, but Joe you may want to just update your patch instead
> since it's more complete.

You have my patch yes?

You can probably integrate and validate it
better than I can with your proposed change.

I don't have any of the hardware to test.
If I can otherwise help somehow, let me know.

cheers, Joe

