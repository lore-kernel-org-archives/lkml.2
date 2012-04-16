Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2DPJBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:01:42 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4041 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2DPJBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:01:40 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F8BDFE7.5070501@broadcom.com>
Date: Mon, 16 Apr 2012 11:01:27 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329
 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "nbowler@elliptictech.com" <nbowler@elliptictech.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "zajec5@gmail.com" <zajec5@gmail.com>
Subject: Re: [PATCH] bcma: use fallback sprom if no on chip sprom is
 available
References: <20120414024430.GA19782@elliptictech.com>
 <1334407134-22803-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1334407134-22803-1-git-send-email-hauke@hauke-m.de>
X-WSS-ID: 63953DBF3E018433162-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 02:38 PM, Hauke Mehrtens wrote:
> bcma should check for a fallback sprom every time it can not find a
> sprom on the card itself or a normal external sprom mapped into the
> memory of the chip. When otp sprom support was introduced it tried to
> read out the sprom from the wireless chip also if no otp sprom was
> available. This caused a Data bus error in bcma_sprom_get() when
> reading out the sprom for the SoC.
>
> This fixes a regression introduced in commit:
>
> commit 10d8493cd9efd38b1947b7a74276dbdc8311aa1a
> Author: Arend van Spriel<arend@broadcom.com>
> Date:   Tue Mar 6 15:50:48 2012 +0100
>
>      bcma: add support for on-chip OTP memory used for SPROM storage
>
> This patch was tested on a Netgear WNDR3400 (Broadcom BCM4718 SoC).
>
> Reported-by: Nick Bowler<nbowler@elliptictech.com>

Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>

Thanks for fixing this. I really need to get my bcm4718 soc up and 
running ;-)

Gr. AvS

