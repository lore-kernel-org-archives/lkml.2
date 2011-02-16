Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1BPHhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:37:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65397 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1BPHhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=q3Y0D2z0822z1YglrBvutf7fDdMapjCeidjwtVWjhniJ1C1I5dQovYLW3rHtvwzdAY
         I8yfp4iJ0Z77Yy3jP66fX3WLixmkL8YHl+RpF2KuhwFoe5DvQE1ASZWwsTUI5yrcC0oh
         3GoJPceko77wyyHS9j02tJhg59VBZap8r9Wdg=
Date: Wed, 16 Feb 2011 10:37:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kay Sievers <kay.sievers@vrfy.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Subject: Re: [114/115] sched: Remove  some dead code
Message-ID: <20110216073701.GS4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
	Mike Galbraith <efault@gmx.de>
References: <20110216014741.GA24678@kroah.com>
 <20110216014705.654816731@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216014705.654816731@clark.kroah.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:46:20PM -0800, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> 
> From: Dan Carpenter <error27@gmail.com>
> 
> commit 618765801ebc271fe0ba3eca99fcfd62a1f786e1 upstream.
> 
> This was left over from "7c9414385e sched: Remove USER_SCHED"
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This is just a cleanup patch.  It doesn't really warrant backporting.

regards,
dan carpenter


