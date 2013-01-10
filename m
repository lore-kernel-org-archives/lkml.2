Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3AJRjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:39:21 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53334 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3AJRjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:39:20 -0500
Message-ID: <50EEFC63.6030904@linux.vnet.ibm.com>
Date: Thu, 10 Jan 2013 09:37:39 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] Add decoder for GFP masks to tools.
References: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com> <20130110113616.GG13304@suse.de>
In-Reply-To: <20130110113616.GG13304@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011017-7282-0000-0000-000012FA5689
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry Mel, you're getting this twice because I forgot CC's last time)
On 01/10/2013 03:36 AM, Mel Gorman wrote:
> Any particular reason you did not use scripts/gfp-translate?

Because I didn't look hard enough & didn't see it :(

> Script is dumb as rocks, requires access to the source code and does not
> translate flag combinations into something like GFP_KERNEL but it's usually
> sufficient. I'm not pushed either way but if you want to push your tool
> then the patch should also delete scripts/gfp-translate.

No preference. Since we have gfp-translate already in tree, it makes 
sense just to keep using it.


