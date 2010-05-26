Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab0EZU3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:29:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35316 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0EZU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=l6alvIxX/Im+z9f3mADTT1nePQ5MNS+5S5V3ReOWGUpYOVIoM8kGjsDiuCG6ctUATP
         wl0Q+sDyqJh6mjeP7r8u9ebIM3OFeSUXjRmRfBfnmSCF7TQDOWYcRgQPyY/GN/7QONEq
         Lw6XAmk64RWhUKIFVPOv0JV9baGv72tWP1NuE=
Date: Wed, 26 May 2010 22:28:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Bashlykov Arthur <madness@xakep.ru>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192su: ieee80211: fix brace coding style
	issue and other issues in ieee80211_softmac_wx.c
Message-ID: <20100526202842.GO22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Denis Kirjanov <kirjanov@gmail.com>,
	Bashlykov Arthur <madness@xakep.ru>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1274891337-7783-1-git-send-email-madness@xakep.ru> <20100526184808.GA6031@coldcone>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526184808.GA6031@coldcone>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:48:08PM +0400, Denis Kirjanov wrote:
> On Wed, May 26, 2010 at 20:28 +0400, Bashlykov Arthur wrote:

> > -	if (!ieee->proto_started){
> > +	if (!ieee->proto_started) {
> >  		ieee->iw_mode = wrqu->mode;
> 
> I guess we can drop braces with single else statement

How Bashlykov has this is proper kernel style because the else statement
has more than one line.

> > -	}else{
> > +	} else {
> >  		ieee80211_stop_protocol(ieee);
> >  		ieee->iw_mode = wrqu->mode;
> >  		ieee80211_start_protocol(ieee);

The rest of your comments were correct of course.  Thanks for reviewing
this patch.

regards,
dan carpenter
