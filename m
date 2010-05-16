Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0EPPwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 11:52:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62599 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab0EPPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 11:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ROkuhCY6kd/IRHDQ7vmDRCB1ZxAr+xA8LstWIZgy8GmBiU22eHic4oU9Uv1AQZH6G2
         WpNsF5uXeLjsSnMj3vjpLrBdA5QDxlT6aTOIzz0ZQ2pvnkVHWBKFC4EGxSBpDnUESH5Q
         O6kDvuFRBvUA49OCVHHy5cKkTVpH3PFJ4kdiQ=
Date: Sun, 16 May 2010 17:50:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 35/37] drivers/block/aoe: Use kmemdup
Message-ID: <20100516155043.GB12354@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ed Cashin <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>
References: <Pine.LNX.4.64.1005152323310.21345@ask.diku.dk> <FA04A0D0-4BAF-4E1D-B8E8-3148E290009F@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA04A0D0-4BAF-4E1D-B8E8-3148E290009F@coraid.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 08:42:59AM -0400, Ed Cashin wrote:
> On May 15, 2010, at 5:23 PM, Julia Lawall wrote:
> 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Use kmemdup when some other buffer is immediately copied into the
> > allocated region.
> 
> I have seen this patch but have no comment about it specifically.
> 
> (Because the argument about whether this kind of change
> adds value in general has already taken place.  I'd say no, but that's 
> based on a maybe faulty idea that if folks weren't doing this they'd have
> more time for reviewing patches, etc.)

Nah nah.  Nit-picky patches like this is what you get when people start
reviewing code.  It's really hard to review code properly without being
annoyed and writing clean up patches is very calming.

git log --pretty=oneline --grep=Lawall

Tons and tons of bugs fixed.

regards,
dan carpenter

