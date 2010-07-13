Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0GMSTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:19:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50674 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0GMSTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kgj33qfev37RQURI4twT2IpvPhCLTTHye+J6DpMnWmMFyE2szfQkrsfeb2icyUax+Q
         nrsiLFUrw4xOEPiFHlg51Soi0tpORY8b+vvBP2c03oDs3k5llSPD4lzlR05YhBGmQWfg
         9MBrRA64vU93CAjxNCu7jnn1DGG+2pkhRzkik=
Date: Tue, 13 Jul 2010 20:19:27 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rt2x00: slow wifi with correct basic rate bitmap (was Re:
 stable? quality assurance?)
Message-ID: <20100713201927.78674c4a@varda>
In-Reply-To: <20100713153530.GC3835@tuxdriver.com>
References: <201007110918.42120.Martin@lichtvoll.de>
	<AANLkTimCwi2uJqqPaq3U30f3rvdDizu1BnaaXgvNeC9k@mail.gmail.com>
	<201007111651.42963.Martin@lichtvoll.de>
	<20100713131112.26a3da54@varda>
	<4C3C6106.3000909@s5r6.in-berlin.de>
	<20100713153530.GC3835@tuxdriver.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 13 Jul 2010 11:35:31 -0400
"John W. Linville" <linville@tuxdriver.com> escribió:


> 
> The patch (7e0986c1) corrects an obvious error.  Reverting it might
> improve your (i.e. Alejandro) performance, but it seems likely to
> cause connectivity problems for others.
> 
> The fact that reverting 7e098c1 helps you suggests that rt2500usb
  
  my card is pci so it would be rt2500pci
  
> isn't using the basic_rates map properly.  But after reviewing the
> code and the data I have, I can't see what would be causing that.
> It is at least possible that your AP is sending bad rate information.
> Have you tried this device with other APs?
 
 No; this is a desktop pc that connects to my home router/AP. A new wifi
 card is cheaper than a new AP ...


> 
> John
