Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0GMSp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:45:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51358 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0GMSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:45:20 -0400
Date: Tue, 13 Jul 2010 14:38:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2x00: slow wifi with correct basic rate bitmap (was Re:
 stable? quality assurance?)
Message-ID: <20100713183851.GD3835@tuxdriver.com>
References: <201007110918.42120.Martin@lichtvoll.de>
 <AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>
 <201007111651.42963.Martin@lichtvoll.de>
 <20100713131112.26a3da54@varda>
 <4C3C6106.3000909@s5r6.in-berlin.de>
 <20100713153530.GC3835@tuxdriver.com>
 <20100713201927.78674c4a@varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100713201927.78674c4a@varda>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 08:19:27PM +0200, Alejandro Riveira Fernández wrote:
> El Tue, 13 Jul 2010 11:35:31 -0400
> "John W. Linville" <linville@tuxdriver.com> escribió:
> 
> 
> > 
> > The patch (7e0986c1) corrects an obvious error.  Reverting it might
> > improve your (i.e. Alejandro) performance, but it seems likely to
> > cause connectivity problems for others.
> > 
> > The fact that reverting 7e098c1 helps you suggests that rt2500usb
>   
>   my card is pci so it would be rt2500pci
  
Sorry, typo...

> > isn't using the basic_rates map properly.  But after reviewing the
> > code and the data I have, I can't see what would be causing that.
> > It is at least possible that your AP is sending bad rate information.
> > Have you tried this device with other APs?
>  
>  No; this is a desktop pc that connects to my home router/AP. A new wifi
>  card is cheaper than a new AP ...

Perhaps you could capture some beacons from that AP?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
