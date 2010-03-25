Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0CYQUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:20:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:42336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab0CYQUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:20:16 -0400
Message-ID: <4BAB8D76.5040104@kernel.org>
Date: Fri, 26 Mar 2010 01:21:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20100323134226.GA14752@havoc.gtf.org> <1269367619.13592.12.camel@mj>
In-Reply-To: <1269367619.13592.12.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Mar 2010 16:18:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 03:06 AM, Pavel Roskin wrote:
> By all means, please push this patch to all stable kernels, or more
> money will be wasted on hard drives ;-)

Oh, the original patch which caused the problem never saw the light of
the day before 2.6.34-rc1 so there's no stable kernel to push the
patch into.

Thanks.

-- 
tejun
