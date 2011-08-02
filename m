Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1HBLiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:38:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47335 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1HBLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:37:59 -0400
Date: Tue, 2 Aug 2011 14:35:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, Tino Keitel <tino.keitel@tikei.de>,
        mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Message-ID: <20110802113554.GC4516@shale.localdomain>
References: <20110722192722.GA9369@x61.home>
 <20110802085447.GA4522@shale.localdomain>
 <20110802115145.25b6a445@schatten.dmk.lab>
 <20110802124028.3b8dcd5a@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802124028.3b8dcd5a@schatten.dmk.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 12:40:28PM +0200, Florian Mickler wrote:
> This should fix it. 
> 

That's not right.  You should just make .size_of_priv = 20 with a
comment.

Btw vp7045_properties is declared twice so it's confusing.  Initially,
I saw the first declaration so I thought .size_of_priv was zero.  I
don't understand why sparse doesn't warn about that.  Could you fix
that as well?

Also I did notice at first that you were the person who added the
.size_of_priv change so that's why I thought someone else must use
that function.

regards,
dan carpenter

