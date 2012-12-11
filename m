Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2LKH6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:58:05 -0500
Received: from mx2.parallels.com ([64.131.90.16]:48424 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2LKH6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:58:03 -0500
Message-ID: <50C6E78B.6010809@parallels.com>
Date: Tue, 11 Dec 2012 11:58:03 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
References: <20121211162210.14ddcdc4d37c40520b0fa88a@canb.auug.org.au>
In-Reply-To: <20121211162210.14ddcdc4d37c40520b0fa88a@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 09:22 AM, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> include/linux/gfp.h between commit caf491916b1c ("Revert "revert "Revert
> "mm: remove __GFP_NO_KSWAPD""" and associated damage") from Linus' tree
> and commit "mm: add a __GFP_KMEMCG flag" from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
Fix is fine, thanks.

