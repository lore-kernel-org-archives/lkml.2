Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0GMTH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:07:57 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60521 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0GMTHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:07:55 -0400
X-Greylist: delayed 3658 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 15:07:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=U8cDErUcqpZcYKRTy1cqnECXbElNActH/aM+YNJXWSqwgp6yjolXhU2vR6qt1eIDyX
         uT9B0U+DxiYq+WBYdAWM8JWoQkC/58itOU8mWx3+iEdlZsk+sT2bSZIA7BLSlsvhpdzi
         gkMZA373ZhTAYeahUNi27ZvdFz3eW0GxpgZTc=
Date: Tue, 13 Jul 2010 21:07:42 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2x00: slow wifi with correct basic rate bitmap (was Re:
 stable? quality assurance?)
Message-ID: <20100713210742.3048ad79@varda>
In-Reply-To: <20100713183851.GD3835@tuxdriver.com>
References: <201007110918.42120.Martin@lichtvoll.de>
	<AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>
	<201007111651.42963.Martin@lichtvoll.de>
	<20100713131112.26a3da54@varda>
	<4C3C6106.3000909@s5r6.in-berlin.de>
	<20100713153530.GC3835@tuxdriver.com>
	<20100713201927.78674c4a@varda>
	<20100713183851.GD3835@tuxdriver.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 13 Jul 2010 14:38:52 -0400
"John W. Linville" <linville@tuxdriver.com> escribió:

> 
> > > isn't using the basic_rates map properly.  But after reviewing the
> > > code and the data I have, I can't see what would be causing that.
> > > It is at least possible that your AP is sending bad rate information.
> > > Have you tried this device with other APs?

 I do no know; i captured some debug data for Ivo back in the day and from
 what he said all the info passed to the card was correct...
 See http://lkml.org/lkml/2009/5/25/163 ( link is in bugzilla) in case
 you missed it

> >  
> >  No; this is a desktop pc that connects to my home router/AP. A new wifi
> >  card is cheaper than a new AP ...
> 
> Perhaps you could capture some beacons from that AP?

  f you explain how; I can try.

> 
