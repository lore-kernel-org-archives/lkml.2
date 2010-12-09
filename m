Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0LILv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 06:51:26 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:63733 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0LILvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 06:51:24 -0500
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291865039.2795.46.camel@edumazet-laptop>
References: <1291863926.2965.1.camel@Dan>
	 <1291865039.2795.46.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 06:51:12 -0500
Message-ID: <1291895472.2965.4.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Thanks for not giving credits to people suggesting this idea to you
> (Thomas if I remember well), and not Ccing netdev where original
> discussion took place. 
> 

I am happy to credit Thomas, even though he is far from the first person
to have suggested this approach to me.  Thanks for the suggestion.

> 
> So caller can not block BH ?
> 
> This seems wrong to me, please consider :
> 
> normal process context :
> 
> spin_lock_bh() ...
> 
> for (...)  
> 	{xxx}printf( ...   "%pK"   ...)
> 
> spin_unlock_bh();
> 

I will think about this and address it.

-Dan

