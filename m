Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1BTCsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 21:48:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64831 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1BTCsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 21:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=usSnGC4E3+UjpHXH1rKqXBCcmCiF5sFjatdNNmR1O16XtvWXVv3msQbJGWquYTo9MJ
         w90DMefbcDI3NDtoc3msmTyeCv/lmqtLcWSsEek7AOxPdv1DDzCvW8q3kHr8ESU3ySEb
         0ksYleIrFf+71q9Z70S7DruIDiSWbCyqT9e/M=
Date: Sun, 20 Feb 2011 10:48:43 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: joe@perches.com
Cc: davem@davemloft.net, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, rdunlap@xenotime.net,
        pavel@ucw.cz
Subject: Re: Fwd: [PATCH]move double quotation marks so that keep
 MAINTAINERS consistent
Message-ID: <20110220024842.GA2138@gmail.com>
References: <20110210025133.GA3285@gmail.com>
 <20110209190631.f29419ef.akpm@linux-foundation.org>
 <20110209.191752.226762899.davem@davemloft.net>
 <20110219164839.GA20047@ucw.cz>
 <1298152790.7179.27.camel@Joe-Laptop>
 <AANLkTi=DbJUFfKA9EMnaUm89Fk2OEDWo64-Lu5H8Yjjv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=DbJUFfKA9EMnaUm89Fk2OEDWo64-Lu5H8Yjjv@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 10:38:06AM +0800, harryxiyou wrote:
> ---------- Forwarded message ----------
> From: Joe Perches <joe@perches.com>
> Date: 2011/2/20
> Subject: Re: [PATCH]move double quotation marks so that keep MAINTAINERS
> consistent
> To: Pavel Machek <pavel@ucw.cz>
> Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
> jiaweiwei.xiyou@gmail.com, linux-kernel@vger.kernel.org, greg@kroah.com,
> rdunlap@xenotime.net
> 
> 
> On Sat, 2011-02-19 at 17:48 +0100, Pavel Machek wrote:
> > On Wed 2011-02-09 19:17:52, David Miller wrote:
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > > I suspect that some mail clients will explode if you provide them with
> > > > an unquoted string containing periods.  That would make copy-n-paste
> > > > rather a hassle.
> > > It's not clients, it's servers.
> > > SMTP rules state that characters such as "." cannot appear
> > > unquoted in email headers.
> > > vger.kernel.org rejects mail when this violation occurs.
> > Ok, but should not MUA do this quotation? Quick test shows that mutt
> does...
> 
> My recollection is that the get_maintainer script
> cannot parse M: lines with multiple entries with
> periods without the quotes.
> 
> M:      First I. Last <fil@foo.bar>, Last.I.First <lif@foo.bar>
> 
> fails and
> 
> M:      "First I. Last" <fil@foo.bar>, "Last.I.First" <lif@foo.bar>
> 
> succeeds.
> 
> You are welcome to improve the parsing in that routine.
Hi Joe,
   	In order to improve the parsing in that routine we should remove all the the double-quotation-marks in the MAINTAINERS ?  Maybe we have other better ways?  Tell me and i will patch for us.
	Like the Greg K-H said, we should firstly notify the maintainers who have the double-quotation-marks in their M:. Then we can make this patch :)
 
Thanks.
Best Regards.
Harry Wei.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!
