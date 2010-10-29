Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088Ab0J2BnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 21:43:19 -0400
Received: from kroah.org ([198.145.64.141]:33686 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127Ab0J2BnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 21:43:08 -0400
Date: Thu, 28 Oct 2010 18:43:54 -0700
From: Greg KH <greg@kroah.com>
To: Konstantin Katuev <kkatuev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging/keucr driver - uninitialized variable &
	proper memset length
Message-ID: <20101029014354.GB9922@kroah.com>
References: <AANLkTi=oFai7Mh_VmzeV1TanF-dfmGs=KWOgj+03V2iH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=oFai7Mh_VmzeV1TanF-dfmGs=KWOgj+03V2iH@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 12:18:18PM +1100, Konstantin Katuev wrote:
> Sorry, i see waste mime characters in my previous post.
> This one shoud be clean.
> 
> There was commented out transfer_flags initialization.
> And i think memset should fill entire structure, not only length of
> pointer to it.
> Driver now works.
> 
> Signed-off-by: Konstantin Katuev <kkatuev@gmail.com>

Looks good, thanks, I'll queue it up for .37-rc1.

thanks,

greg k-h
