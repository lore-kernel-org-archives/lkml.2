Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0EXWmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:42:01 -0400
Received: from kroah.org ([198.145.64.141]:42444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab0EXWle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:41:34 -0400
Date: Mon, 24 May 2010 15:38:43 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       stable@kernel.org
Subject: Re: [stable] [PATCH] Revert "ath9k: fix lockdep warning when
 unloading module" on stable kernels
Message-ID: <20100524223843.GA1261@kroah.com>
References: <1274304829-14367-1-git-send-email-lrodriguez@atheros.com>
 <20100524215216.GJ16655@kroah.com>
 <AANLkTinhpYvUrxIw9-eZG3ihyshCZiSZP9wQ7ThLs_kx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinhpYvUrxIw9-eZG3ihyshCZiSZP9wQ7ThLs_kx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 03:16:37PM -0700, Luis R. Rodriguez wrote:
> >
> > For some reason, you never signed-off on this patch, why?  Care to send
> > me a "Signed-off-by:" line so I can add it?
> 
> WTF, sorry, you're right, can you just peg it for me?
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Yes, I'll go add it to the patch, thanks.

greg k-h
