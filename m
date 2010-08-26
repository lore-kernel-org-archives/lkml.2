Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0HZL4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:56:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:47667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0HZL4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:56:14 -0400
Date: Thu, 26 Aug 2010 13:56:12 +0200
From: Michal Marek <mmarek@suse.cz>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][resend] scripts/mod/modpost.c: fix commentary
 accordingly to last changes
Message-ID: <20100826115611.GA24170@sepie.suse.cz>
References: <1282041400-32667-1-git-send-email-ext-andriy.shevchenko@nokia.com>
 <20100823065233.GM5168@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100823065233.GM5168@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 02:52:33PM +0800, Américo Wang wrote:
> On Tue, Aug 17, 2010 at 01:36:40PM +0300, Andy Shevchenko wrote:
> >The last commits
> > 37ed19d5cce35a40d3913cf9aa208ce9f60db3d7
> > 5003bab82d56754b27be01eef24495a02e00039d
> >have introduced new behaviour of sec2annotation() method. However, the
> >commentary inside the method was left as before. Let's fix it accordingly.
> >
> >Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> >Cc: Rusty Russell <rusty@rustcorp.com.au>
> >Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied, thanks.

Michal
