Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2BBAFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:05:01 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39108 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2BBAFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:05:00 -0500
Date: Thu, 2 Feb 2012 11:04:51 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [06/20] crypto: sha512 - reduce stack usage to safe number
Message-ID: <20120202000450.GA18441@gondor.apana.org.au>
References: <20120201210055.GA25374@kroah.com> <20120201201531.599621544@clark.kroah.org> <20120201234208.GA28700@p183.telecom.by> <20120201235204.GA18950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201235204.GA18950@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:52:04PM -0800, Greg KH wrote:
>
> But this patch isn't in Linus's tree yet, right?
> 
> So, should I just drop this one for now (well both of them) or just wait
> for the above referenced patch to hit Linus's tree and handle it then?

We're still working on the i386 issue.  However, I'd say that
you should take these two patches now since the problem they
fix is far worse than the potential stack issue on i386.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
