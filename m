Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0HZXds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:33:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1444 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0HZXdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:33:43 -0400
Date: Thu, 26 Aug 2010 16:33:38 -0700 (PDT)
From: Joe Perches <joe@perches.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        <platform-driver-x86@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
In-Reply-To: <1282865341-17607-1-git-send-email-cesarb@cesarb.net>
Message-ID: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Cesar Eduardo Barros wrote:

> On my Dell Inspiron N4010, one of these messages is printed every five
> seconds. Change both to dev_dbg to quieten them even more.

I think you should instead fix your hardware or maybe change
your thermal throttling settings.

> @@ -607,7 +607,7 @@ static bool mcp_exceeded(struct ips_driver *ips)
> -		dev_info(&ips->dev->dev,
> +		dev_dbg(&ips->dev->dev,
>  			 "MCP power or thermal limit exceeded\n");

