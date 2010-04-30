Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab0D3SyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:54:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56306 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934047Ab0D3Sx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=meIgaTDTyHur+jMcmwCRO+sIG5oSvUr3eiorfSnd5XNn3qYJ0Rzyw6VR9dml49EeId
         l7AqntgEJTdQ7dsQKFYOXVF0lpNV14e0T7l46ZY/sq8zvn09PMPYSEgSsdiaufrUJHsW
         JgbkzfOSlnO2qwORl3ulA9IVSDqLrSjpBku2A=
Date: Fri, 30 Apr 2010 04:18:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: dgilbert@interlog.com, Jens Axboe <axboe@kernel.dk>,
       Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi/st: remove BKL from open
Message-ID: <20100430021855.GA21078@nowhere>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <201004151629.45029.arnd@arndb.de> <alpine.LNX.2.00.1004152244160.5127@kai.makisara.local> <201004152251.39636.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004152251.39636.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 10:51:38PM +0200, Arnd Bergmann wrote:
> The st_open function is serialized through the st_dev_arr_lock
> and the STp->in_use flag, so there is no race that the BKL
> can protect against in the driver itself, and the function
> does not access any global state outside of the driver that
> might be protected with the BKL.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---



Kai, can we get your ack on this?

Thanks.

