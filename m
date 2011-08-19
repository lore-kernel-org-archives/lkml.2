Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1HSJE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:04:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44572 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1HSJE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:04:56 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Subject: Re: ARM promising platform, needs to learn from PC.
Date: Fri, 19 Aug 2011 11:04:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-10-server; KDE/4.6.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com> <CAPweEDzY7BQ_yxY1hVZdW8dL4GzQ_t=0KcXP_Mp45XrRShJ14Q@mail.gmail.com>
In-Reply-To: <CAPweEDzY7BQ_yxY1hVZdW8dL4GzQ_t=0KcXP_Mp45XrRShJ14Q@mail.gmail.com>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108191104.44422.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday 19 August 2011 04:02:33 Luke Kenneth Casson Leighton wrote:
> dear linus,
> 
> i've written this up, including some examples in FAQ form that would
> and would not satisfy the proposed "selfish-is-out, cooperation-is-in"
> patch-acceptance rule, here:
> http://lkcl.net/linux/linux-selfish.vs.cooperation.html
> 
> comments greatly appreciated, as would additional examples to add to the
> FAQ.

Most of your examples, especially the RDC is example is just badly chosen.

I had patches supporting this sub arch acccepted until we could get rid of it 
and make it work with the generic x86 infrastructure. The only thing that has 
not been accepted yet is some kind of "cpuid-like" feature for RDC.

The rdc321x GPIO driver has been accepted mainline and only serves on RDC-
based SoC.

Sorry to say that, but I do not understand the point of your FAQ, most people, 
if explained with good reasons, would accept a new architecture/SoC/sub-arch, 
but that's also at the price of the submitter to eventually rethink its way of 
supporting the architecture (Device Tree, code re-organisation ...).
-- 
Florian
