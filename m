Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1CVFqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:46:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52224 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1CVFqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LfX60VIiAyRCMAYuFONJwk0XpBEpT2pWon/G1nhYV2NqQUKUZDqUtoRfiV4o/znWmP
         bQONWc1fUR3RudtmRjB3AjCH/yfG0UsaLpRn8Dpd5D5Hr2wIKTqLRFjmEEdoXNOJ9CFC
         iLnc+Wu8G+2oruk0arTGSbI8R/xikkUHASeFA=
Date: Tue, 22 Mar 2011 13:46:22 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC]A question about kernel's development
Message-ID: <20110322054619.GB2856@gmail.com>
Mail-Followup-To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20110322033312.GA2219@gmail.com>
 <20110322035646.GA17601@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322035646.GA17601@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 08:56:46PM -0700, Greg KH wrote:
> On Tue, Mar 22, 2011 at 11:33:14AM +0800, Harry Wei wrote:
> > Hi us,
> >    I wanna know our kernel's development 
> > procedure for details. I just realize
> > when we get a stable release, we must 
> > merge trementous patches into kernel.
> > I often watch -rc kernels, -git kernels, 
> > , -mm kernels and know their promulgators.
> > But i don't know their relationships and
> > sequences for shaping stable ones.
> >    Okay, now we want to develop 2.6.38 
> > to 2.6.39. How many specific steps should we
> > do? In fact, i recognize some. But i want to 
> > understand all the concrete procedures. Could
> > anyone help me, thanks in advance.
> 
> Please read Documentation/HOWTO and Documentation/development_process/
> for all of the details.
> 
> If you have specific questions after reading all of that, please let us
> know.
Thanks, i will :)

Thanks.
Best Regards.
Harry Wei.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
