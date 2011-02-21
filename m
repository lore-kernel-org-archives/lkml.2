Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab1BUFH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:07:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59036 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1BUFHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=V1+dFIMO218Y1Uxu0YLQPJp7uNHfxsyI8tKGuODB4rf5jGVcG7Gpybem+mec8sm9x5
         f3dcBKdS72uTsU97P8nP42GBWYB5lwE7U1OFXSVI+O3jnULrJPjgHiscFtiGN86jJejr
         r5ASInnnGxOrJXKwbmk2zOKfXBSbHqjyIzk4E=
Date: Mon, 21 Feb 2011 13:07:46 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: joe@perches.com
Cc: davem@davemloft.net, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, rdunlap@xenotime.net,
        pavel@ucw.cz
Subject: Re: Fwd: [PATCH] MAINTAINERS: Quote non-alphanumeric email
 addresses
Message-ID: <20110221050744.GA2213@gmail.com>
References: <20110209190631.f29419ef.akpm@linux-foundation.org>
 <20110209.191752.226762899.davem@davemloft.net>
 <20110219164839.GA20047@ucw.cz>
 <1298152790.7179.27.camel@Joe-Laptop>
 <AANLkTi=DbJUFfKA9EMnaUm89Fk2OEDWo64-Lu5H8Yjjv@mail.gmail.com>
 <20110220024842.GA2138@gmail.com>
 <1298177214.7179.55.camel@Joe-Laptop>
 <20110220135918.GB1972@gmail.com>
 <1298217622.7179.93.camel@Joe-Laptop>
 <AANLkTi=qeg6jUBY-D68EW3bK_6EZRrXBE+JRj6GO92v2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=qeg6jUBY-D68EW3bK_6EZRrXBE+JRj6GO92v2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:59:16PM +0800, jiaweiwei wrote:
> ---------- Forwarded message ----------
> From: Joe Perches <joe@perches.com>
> Date: 2011/2/21
> Subject: Re: [PATCH] MAINTAINERS: Quote non-alphanumeric email addresses
> To: Harry Wei <jiaweiwei.xiyou@gmail.com>
> Cc: davem@davemloft.net, akpm@linux-foundation.org,
> linux-kernel@vger.kernel.org, greg@kroah.com, rdunlap@xenotime.net,
> pavel@ucw.cz
> 
> 
> On Sun, 2011-02-20 at 21:59 +0800, Harry Wei wrote:
> > On Sat, Feb 19, 2011 at 08:46:54PM -0800, Joe Perches wrote:
> > > Add quotes around email address with periods and commas.
> > Hmm, what about some other conditions except
> > for periods and commas in maintainers' M:.
> > Like following:
> > 1> Character '-' in M:
> 
> Dashes are not an issue.
Get it.
> 
> > 2> No name of the M:
> > M:      support@lsi.com
> 
> Names and angle brackets are optional.
Ok.
> 
> > 3> Messy code in M:
> > M:      Benoît Cousson <b-cousson@ti.com>
> 
> 8 bit characters _might_ be an issue, but
> no one has reported any problems yet.
Get it. 
> 
> I think you should read and understand rfc 2822
> before continuing with this.
Thanks, i will read it :)
> 
> Utilities like git send-email and get_maintainer.pl
> generally provide email address parsing for only a
> subset of all valid address styles.
> 
> As these utilities are done mostly by regex, not
> all valid email addresses are supported because the
> regex validations get ridiculously complicated.
> 
> There are some "monster" regex classes that attempt
> to support a greater range of valid email address
> styles, but the pain of implementation generally
> isn't worth it.
> 
> You're free to try to improve it of course, but I
> think that modifications to the address styles
> currently used in MAINTAINERS to remove "special"
> address style handling isn't necessary.
Get it, thanks.

Best Regards.
Harry Wei.
> 
> 
> 
> 
> -- 
>  do kernel
