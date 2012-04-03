Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2DCFFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:05:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51238 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2DCFFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:05:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAAE6i0hHT7A+x7Q9zct0oxQv44Y8WchiKdeRbNrzRRp+fJNGuQ@mail.gmail.com>
References: <CAAE6i0hHT7A+x7Q9zct0oxQv44Y8WchiKdeRbNrzRRp+fJNGuQ@mail.gmail.com>
From: Chester <somethingsome2000@gmail.com>
Date: Tue, 3 Apr 2012 00:05:14 -0500
Message-ID: <CAAE6i0gVsYnpa82FrKCNV5sszr38But4Og6D20cv4r8BF3Tv=Q@mail.gmail.com>
Subject: Re: brcmsmac driver is ghost in 3.3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And this is when I curse at all the google results that say "blacklist
bcma" ... brcmsmac DEPENDS on bcma /facepalms and goes to sleep..

On Mon, Apr 2, 2012 at 11:50 PM, Chester
> I spent the better part of my day trying to get my bcm4313 wlan card
> to work with the new kernel to little success. I used to use brcmsmac
> with the old 3.2 kernel, but it was somehow excluded when I did my
> 'make silentoldconfig'.
>
> I chose b43 because I couldn't find brcmsmac anywhere in nconfig
> anymore. device drivers -> network devices -> wireless lan -> ???..
> After fiddling around a while, I looked into my .config and searched
> for the symbol, and sure enough, it was there! CONFIG_BRCMSMAC is not
> set.
>
> That's strange. I get back on nconfig and do a symbol search and find
> that it should be in devices drivers -> network devices -> wireless
> lan. I go check a 2nd time and it's right there! Broadcom SoftMac
> driver! .. I tried enabling it and saving the config. I peaked at the
> .config file again, and the symbol was _gone_ .. (??) I got back on
> nconfig and the option was no longer there as well.
