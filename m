Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab1KHTXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:23:42 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26236 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab1KHTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:23:42 -0500
Date: Tue, 8 Nov 2011 20:29:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Thomas Meyer <thomas@m3y3r.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc
In-Reply-To: <1320779913.8062.147.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1111082027000.5763@swampdragon.chaosbits.net>
References: <1320779913.8062.147.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Thomas Meyer wrote:

> From: Thomas Meyer <thomas@m3y3r.de>
> 

You should seriously consider giving your patch mails unique subjects.

Many patches with identical subjects are prone to be missed by people on 
the list and it's also harder to refer to a specific patch later.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

