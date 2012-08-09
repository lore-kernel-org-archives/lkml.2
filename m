Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2HIUrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:47:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44015 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2HIUrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:47:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFnGceMnxMphBu2R4d9S5P116tTYJy5zu4XOeQftB8BR7B-tg@mail.gmail.com>
References: <CAAFnGceMnxMphBu2R4d9S5P116tTYJy5zu4XOeQftB8BR7B-tg@mail.gmail.com>
Date: Thu, 9 Aug 2012 22:47:40 +0200
Message-ID: <CAAFnGcesH1xHA9mO04+dbrVc2KSO0R1b6=9ptMRi9KCHx5+BDA@mail.gmail.com>
Subject: Re: Ralink RT3070 driver
From: Marco Bellinati <hvit.marco@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two USB wireless card with Ralink RT3070 chip, this is the lsusb
Bus 001 Device 013: ID 148f:3070 Ralink Technology, Corp.
RT2870/RT3070 Wireless Adapter
I connect to a router which is 200mt away so i always connect with low signal.
With kernels up to 3.3.x I hadn't any problem with the rt2800usb
driver. Since kernel 3.4.x I can't connect, connection just timeout
while authenticating. Using Ralink driver I can connect even tho it's
a little unstable and bugged.
Since kernel 3.5 I'm experiencing some problems connecting with the
ralink driver too, always with the timeout problem.
I'm experiencing the same problem with both my Asus EEEPC 1000H and my
Dell Latitude e5420 using Fedora 17 and Archlinux, I tried wicd and
networkmanager to manage the connection.
Marco
