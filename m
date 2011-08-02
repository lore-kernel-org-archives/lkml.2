Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1HBLm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:42:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41897 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1HBLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:42:40 -0400
Date: Tue, 2 Aug 2011 14:40:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, Tino Keitel <tino.keitel@tikei.de>,
        mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Message-ID: <20110802114037.GD4516@shale.localdomain>
References: <20110722192722.GA9369@x61.home>
 <20110802085447.GA4522@shale.localdomain>
 <20110802115145.25b6a445@schatten.dmk.lab>
 <20110802124028.3b8dcd5a@schatten.dmk.lab>
 <20110802113554.GC4516@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802113554.GC4516@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 02:35:54PM +0300, Dan Carpenter wrote:
> Also I did notice at first that you were the person who added the
> .size_of_priv change so that's why I thought someone else must use
> that function.

Grr...  That made no sense.

I thought someone else set .size_of_priv and was using the pointer.
But actually it was you who set the .size_of_priv and no one else
is using it.

regards,
dan carpenter
