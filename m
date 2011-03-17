Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1CQWLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:11:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab1CQWLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:11:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Thu, 17 Mar 2011 23:11:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20110311161421.GA7843@kroah.com> <20110317201835.GM31411@opensource.wolfsonmicro.com> <20110317202614.GA3155@kroah.com>
In-Reply-To: <20110317202614.GA3155@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103172311.36246.arnd@arndb.de>
X-Provags-ID: V02:K0:XU2SrH7kx3lMz4X6KFklVyr4siN0nDfCtOavMoublnB
 ow5TzEDtDClM61cxmrYEwZM7qMuABTbNO28BicvQfermNFLeud
 roznG5L2bUbBhW00Bi/1V4NSogZLY2qAROS2QJ39vltg/ws5NC
 m11ZLGp3c6HPIH4qYJp48Pg2tUSkEIt9yTuZYOm54Iog+SNTav
 I3JnqfoeUWYACLHnxKxig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011 21:26:14 Greg KH wrote:
> > It's going to be an off the shelf USB ethernet controller.  I'd be
> > astonished if the board-configurable device IDs weren't set from the
> > same SEPROM that the MAC address is so it'd just show up as a generic
> > chip of whatever kind.
> 
> Huh?  All USB controllers you buy have the ability to set the vendor and
> product id, so you should always be able to key off of that.
> 
> Isn't that the case here?

The same EEPROM that is missing here carries both the MAC address and
the vendor/product ID overrides.

	Arnd
