Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0IFUXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:23:00 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:39774 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0IFUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:22:54 -0400
MIME-Version: 1.0
Date: Mon, 06 Sep 2010 15:22:57 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: venki kaps <venkiece2005@gmail.com>
Cc: <tom.leiming@gmail.com>, <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Anand Gadiyar <gadiyar@ti.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
In-Reply-To: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com>
Message-ID: <0dfed6f7fe2c07da3ce8108a4c5620c3@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 7 Sep 2010 03:10:30 +0900, venki kaps <venkiece2005@gmail.com>
wrote:
> Dear USB experts,
> 
>   Is the same fix valid for omap3430 + 2.6.32 Kernel?

3.6.32 ?? difficult to say. Why such an old kernel ? Although
I doubt musb or twl4030-usb driver has changed that much, it's
difficult to say.

>   I have been facing mp3 playback idle current consumption 20mA more
> after booting without USB cable connected

let me see if I understand you right. The consumption is higher
when the cable is kept plugged or the consumption is higher if
you boot with usb cable pugged and remove it afterwards ?

-- 
balbi
