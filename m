Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1EEMdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:33:53 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4864 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab1EEMdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:33:52 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DC2991F.6030703@broadcom.com>
Date: Thu, 5 May 2011 14:33:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Arnd Bergmann" <arnd@arndb.de>, "George Kashperko" <george@znau.edu.ua>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>, "Andy Botting" <andy@andybotting.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: AXI driver status => previously: Re: Could I (ab)use bus
 (struct bus_type) for virtual Broadcom bus?
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
 <201104171938.12834.arnd@arndb.de> <op.vt6ufu1n3ri7v4@arend-laptop>
 <201104191635.40351.arnd@arndb.de> <op.vt76hofg3ri7v4@arend-laptop>
 <BANLkTinMe-KedeOAiQYES-LCC2O4BoE28w@mail.gmail.com>
In-Reply-To: <BANLkTinMe-KedeOAiQYES-LCC2O4BoE28w@mail.gmail.com>
X-WSS-ID: 61DC46674NS1013087-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 09:29 AM, Rafał Miłecki wrote:
> I do not register that exceptional devices in my code.

Hi Rafał,

There has been some radio silence on the subject of the (bcm)axi driver. 
I was getting a feeling that my concerns were almost all out of the way 
in latest emails I got from Arnd and/or Jonas. Do you have an update of 
what plans you have with this module.

Gr. AvS


