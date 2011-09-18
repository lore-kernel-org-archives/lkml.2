Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1IRSNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 14:13:46 -0400
Received: from lucidpixels.com ([72.73.18.11]:49358 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1IRSNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 14:13:45 -0400
Date: Sun, 18 Sep 2011 14:13:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc4: LinkUSBi - digitemp/sensors not working : Error 10:
 Read COM Failed
In-Reply-To: <alpine.DEB.2.02.1109181320500.7278@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1109181413120.20777@p34.internal.lan>
References: <alpine.DEB.2.02.1109181320500.7278@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Sep 2011, Justin Piszcz wrote:

> Hi,
>
> I have two LinkUSBi wireless temperature sensors (masters) and both work
> fine in Windows 7, I got them both to work in Linux once but I did not
> record how I did it-- does anyone know why the following happens?
>
> You are only supposed to use digitemp_ds9097u but including all just
> incase someone mentions trying the other two :)
>
> --

This commit seems to have fixed the issue a few kernels ago (based on some
reading; however with 3.1-rc4 it is still failing, any thoughts?)
http://git.strongswan.org/?p=linux-dumm.git;a=commit;h=677aeafe19e88c282af74564048243ccabb1c590

Justin.

