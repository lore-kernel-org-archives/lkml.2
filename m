Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab0D3S5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:57:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab0D3RGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:06:39 -0400
Message-ID: <4BD919F5.1080508@kernel.org>
Date: Thu, 29 Apr 2010 07:32:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mackerras <paulus@au1.ibm.com>
CC: trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org> <20100428215550.GB5597@brick.ozlabs.ibm.com>
In-Reply-To: <20100428215550.GB5597@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 05:32:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/28/2010 11:55 PM, Paul Mackerras wrote:
> Trouble is, the lawyers tell us that "(C)" is legally meaningless.

Ah... okay.

> However, "Copyright" on its own is enough, so if the copyright symbol
> annoys you, we could just remove it.

That's relieving.  It sure is an annoyance for anyone who's not on
latin-1.  It's an outright invalid character and as you've seen it's
not easy to even send a patch changing it.  IMHO, if it were something
which couldn't be avoided at all, encoding it using utf-8 would be
much more appropriate.

Thanks.

-- 
tejun
