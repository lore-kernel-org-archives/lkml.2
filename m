Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2DSJTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:19:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47035 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859Ab2DSJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:19:29 -0400
Date: Thu, 19 Apr 2012 10:19:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemleak: do not leak object after tree insertion
 error (v3)
Message-ID: <20120419091917.GA23597@arm.com>
References: <20120418154448.GA3617@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418154448.GA3617@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:44:48PM +0100, Sergey Senozhatsky wrote:
>  [PATCH] kmemleak: do not leak object after tree insertion error
> 
>  In case when tree insertion fails due to already existing object
>  error, pointer to allocated object gets lost because of overwrite
>  with lookup_object() return. Free allocated object before object
>  lookup. 
> 
>  Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks. I applied it to my kmemleak branch and I'll send it to Linus at
some point (during the next merging window).

-- 
Catalin
