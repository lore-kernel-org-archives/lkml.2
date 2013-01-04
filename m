Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3ADSIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:08:01 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56664 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab3ADSH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:07:59 -0500
Date: Fri, 4 Jan 2013 12:07:55 -0600
From: Ben Myers <bpm@sgi.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH -v2 12/26] xfs: rename random32() to prandom_u32()
Message-ID: <20130104180755.GE30652@sgi.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
 <1357215562-6288-13-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357215562-6288-13-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu,

On Thu, Jan 03, 2013 at 09:19:08PM +0900, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: xfs@oss.sgi.com

I didn't realize that random32 was a PRNG.  Thanks.

Acked-by: <bpm@sgi.com>

