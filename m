Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0LIMqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:46:52 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:60614 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0LIMqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:46:51 -0500
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291895472.2965.4.camel@Dan>
References: <1291863926.2965.1.camel@Dan>
	 <1291865039.2795.46.camel@edumazet-laptop>  <1291895472.2965.4.camel@Dan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 07:46:41 -0500
Message-ID: <1291898801.2965.6.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > So caller can not block BH ?
> > 
> > This seems wrong to me, please consider :
> > 
> > normal process context :
> > 
> > spin_lock_bh() ...
> > 
> > for (...)  
> > 	{xxx}printf( ...   "%pK"   ...)
> > 
> > spin_unlock_bh();
> > 
> 
> I will think about this and address it.

Would you be happier if I omitted the in_interrupt() check entirely?

-Dan

