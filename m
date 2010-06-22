Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0FVSPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:15:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0FVSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:15:17 -0400
Date: Tue, 22 Jun 2010 14:13:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5 v2]wireless:hostap_main.c warning: variable 'iface'
 set but not used
Message-ID: <20100622181320.GD2583@tuxdriver.com>
References: <1277157733-14071-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277157733-14071-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:02:13PM -0700, Justin P. Mattock wrote:
> This is a resend from version one due to trying a different approach
> than the original(probably important to leave netdev_priv() in).
> 
> In any case have a look, if there's another approach let me know
> and ill test it out. The below patch fixes a warning im seeing
> when compiling with gcc 4.6.0
> 
> CC [M]  drivers/net/wireless/hostap/hostap_main.o
> drivers/net/wireless/hostap/hostap_main.c: In function 'hostap_set_multicast_list_queue':
> drivers/net/wireless/hostap/hostap_main.c:744:27: warning: variable 'iface' set but not used
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

I already applied the other version to wireless-next-2.6.  I can't
imagine what you mean to accomplish by leaving in a call to netdev_priv
w/o assigning the result to something.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
