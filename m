Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1DUQtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:49:46 -0400
Received: from mail.perches.com ([173.55.12.10]:4870 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1DUQto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:49:44 -0400
Subject: Re: [PATCH] tg3: Convert u32 flag,flg2,flg3 uses to bitmap
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303374696.3685.14.camel@edumazet-laptop>
References: <1303322263-18991-10-git-send-email-mcarlson@broadcom.com>
	 <02bf2aa5c08514641ecbe7c39ef976918fad036c.1303367730.git.joe@perches.com>
	 <1303374696.3685.14.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 09:49:43 -0700
Message-ID: <1303404583.24766.63.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 10:31 +0200, Eric Dumazet wrote:
> Le mercredi 20 avril 2011 à 23:39 -0700, Joe Perches a écrit :
> > Using a bitmap instead of separate u32 flags allows a consistent, simpler
[]
> Use an enum ?

No strong preference.
If it's an enum .c file will change.
	
> Why first value is 1 and not 0 ?

Should be 0.

> > +#define TG3_FLAGS			74	/* Set to number of flags */
> Also you need to make TG3_FLAGS be (last_flag_value + 1) or you could
> miss one long in bitmap.

Right.  Thanks for comments Eric.
I'll wait for Matt to comment before resubmitting.

