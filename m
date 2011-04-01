Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1DATnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:43:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1DATna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:43:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Aloisio Almeida <aloisio.almeida@openbossa.org>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Fri, 1 Apr 2011 21:43:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, Waldemar.Rymarkiewicz@tieto.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com,
        alan@lxorguk.ukuu.org.uk, Sebastian.Chlad@tieto.com
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <20110331153010.GD2704@sortiz-mobl> <AANLkTikjTAFrhS7_P+KJ-r-33K6fW2+63OnLhjXE-u0k@mail.gmail.com>
In-Reply-To: <AANLkTikjTAFrhS7_P+KJ-r-33K6fW2+63OnLhjXE-u0k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104012143.23261.arnd@arndb.de>
X-Provags-ID: V02:K0:AdrcsSORedJu7dQ9Ha+rMhM9CuGwNJEzDyRzNj48pOK
 WjN5gVzaLVtJQubdrRjnDrkFHUj1nsdX/IljgHTJAa9EdKy4pO
 iEEZWDnuMIMytbAMLxyhM15SSPciV+QP0oIsv85flhcjpwuFnQ
 LOgk4HH/rXDTZDdxax1hb+cJdZAEBhQ/kqtwyLnKooPzrSYhR8
 OMw2aY9eyq4o18s6h1mKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011 20:19:30 Aloisio Almeida wrote:
> We are finalizing a NFC stack prototype and we decided to use generic
> netlink. But during the implementation we found a disadvantage of this
> approach.
> 
> While implementing data_exchange through netlink, it was not possible
> to avoid memcpy as the skbuff coming from netlink can contain more
> than one message.

I don't think anyone in this thread suggested using netlink for user
data.

> We didn't find any implementation that uses netlink to exchage data.
> As in the nl80211, the netlink is used only for control commands.

Yes, that is the normal way to do it.
 
> We plan to publish for comments this prototype early next week. Then
> we plan to implement a version using AF_NFC.

Sounds good.
	
	Arnd
