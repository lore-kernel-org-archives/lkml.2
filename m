Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1HBUd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:33:57 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:47081 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab1HBUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:33:50 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Aug 2011 16:33:50 EDT
Message-ID: <4E385DF7.5010206@tilera.com>
Date: Tue, 2 Aug 2011 16:28:39 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: <trivial@kernel.org>, <kernel-janitors@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/11] arch/tile/mm/init.c: trivial: use BUG_ON
References: <1312281304-11847-1-git-send-email-julia@diku.dk> <1312281304-11847-12-git-send-email-julia@diku.dk>
In-Reply-To: <1312281304-11847-12-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/2011 6:35 AM, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Use BUG_ON(x) rather than if(x) BUG();

Thanks, accepted into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

