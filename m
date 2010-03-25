Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0CYMHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:07:10 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63101 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0CYMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=x7NMsfudb68LWMxsyvNJfESBzwhdda6CDFBkJisMX5IRWB8nNiKIScvQfOyQROoBkq
         T5XvPnF0tCGQ9kxHznfD9Zajlxl+DC4HDhhtz2ZK4QQAf8uqYRkIKlLH57UKyGSnYwep
         ATe7TEw1ggOFoRrBvp2lF5xJNebny9uyiADm0=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 0/4 v3] RDC321x southbridge and GPIO support
Date: Thu, 25 Mar 2010 13:06:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-server; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wim@iguana.be
References: <201003210106.01673.florian@openwrt.org> <20100325112727.GC3720@sortiz.org> <20100325113512.GA9594@sortiz.org>
In-Reply-To: <20100325113512.GA9594@sortiz.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003251306.37491.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010 12:35:13 Samuel Ortiz wrote:
> On Thu, Mar 25, 2010 at 12:27:27PM +0100, Samuel Ortiz wrote:
> > Hi Florian,
> >
> > On Sun, Mar 21, 2010 at 01:06:01AM +0100, Florian Fainelli wrote:
> > > Hi Samuel, Andrew,
> > >
> > > This is the third round of the RDC321x southbridge and GPIO support,
> > > this version should hopefully address all of your comments.
> >
> > All 4 (I took v2 for the watchdog) patches applies, thanks.
> 
> Nevermind, I had to take v3 version for the watchdog, although I couldnt
>  find it in my inbox.

Thank you!
