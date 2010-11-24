Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0KXPBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:01:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1852 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0KXPBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:01:18 -0500
Subject: Re: [PATCH] quota: Use %pV and __attribute__((format (printf in
 __quota_error and fix fallout
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20101124125029.GO6113@quack.suse.cz>
References: <1290566994.11971.26.camel@Joe-Laptop>
	 <20101124125029.GO6113@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 07:01:17 -0800
Message-ID: <1290610877.11971.59.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 13:50 +0100, Jan Kara wrote:
> On Tue 23-11-10 18:49:54, Joe Perches wrote:
> > Use %pV in __quota_error so a single printk can not be
> > interleaved with other logging messages.
> > Add __attribute__((format (printf, 3, 4))) so format
> > and arguments can be verified by compiler.
> > Make sure printk formats and arguments match.
> > 
> > Block # needed a pointer dereference.
>   I already had a similar patch from you in my tree. So I've replaced it.

Perhaps you can get your tree into linux-next.

I believe you only have to send a request to
Stephen Rothwell (cc'd).


