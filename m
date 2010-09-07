Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0IGMq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:46:58 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:33752 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab0IGMqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:46:53 -0400
MIME-Version: 1.0
Date: Tue, 07 Sep 2010 07:46:54 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: venki kaps <venkiece2005@gmail.com>
Cc: <tom.leiming@gmail.com>, <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Anand Gadiyar <gadiyar@ti.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization(v1)
In-Reply-To: <AANLkTinGSXdfWBABm9dmGDxnbf-_udg0ZvVCyH8FX-aO@mail.gmail.com>
References: <AANLkTinnHiCodvHrSxiMCAQXAETczRiZ+sDu2aQXSeG0@mail.gmail.com> <0dfed6f7fe2c07da3ce8108a4c5620c3@secure211.sgcpanel.com> <AANLkTinGSXdfWBABm9dmGDxnbf-_udg0ZvVCyH8FX-aO@mail.gmail.com>
Message-ID: <e07f55b5f77ea471f41353190431bc78@secure211.sgcpanel.com>
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

On Tue, 7 Sep 2010 11:49:38 +0900, venki kaps <venkiece2005@gmail.com>
wrote:
>> let me see if I understand you right. The consumption is higher
>> when the cable is kept plugged or the consumption is higher if
>> you boot with usb cable pugged and remove it afterwards ?
>   >> The consumption is higher if boot without usb cable.If boot when
> the cable is kept plugged
>   >> and remove it afterwards, then normal.

ok, so that's what I had observed and my original patch is the one
you want. You probably _also_ want this one though due the WARN

-- 
balbi
