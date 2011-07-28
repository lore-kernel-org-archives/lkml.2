Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1G1LKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:10:13 -0400
Received: from smarthost04.mail.zen.net.uk ([212.23.3.143]:48597 "EHLO
	smarthost04.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab1G1LKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:10:11 -0400
From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>
Organization: Sphere Systems Ltd
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH 1/4] USB: option driver: add PID for Vodafone-Huawei K3770
Date: Thu, 28 Jul 2011 12:10:05 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-35.fc15.i686; KDE/4.6.5; i686; ; )
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk> <4E3140D2.90608@ru.mvista.com>
In-Reply-To: <4E3140D2.90608@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107281210.06455.ajb@spheresystems.co.uk>
X-Originating-Smarthost04-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Thursday 28 July 2011, Sergei Shtylyov wrote:
> Hello.
> 
> On 27-07-2011 20:03, Andrew Bird wrote:
> > This patch adds the product ID of Huawei's Vodafone K3770 mobile
> > broadband modem to option.c. This is necessary so that the driver gets
> > loaded on demand without the intervention of usb_modeswitch. This has
> > the benefit of it becoming available faster and also ensures that the
> > option driver is not bound to a network interface that should be claimed
> > by cdc_ether.
> 
>     You seem to be adding 4 product IDs with the identical patch
> descriptions. Why not do it in a single patch?
> 
> > Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
> 
> WBR, Sergei

	I'm pretty new to this, but I was following the one patch per change 
idea, so as there are four devices I did a patch for each.

Happy to squash into one if that's more acceptable to people?


Andrew
