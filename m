Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1E1TwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 15:52:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38153 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1E1TwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 15:52:03 -0400
Message-ID: <4DE151DA.7050701@dthaler.de>
Date: Sat, 28 May 2011 21:49:46 +0200
From: Daniel Thaler <daniel@dthaler.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110502 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.39 kernel panic w/screenshots & kernel cfg link provided
References: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2011 14:01, Justin Piszcz wrote:
> Hello,
>
> Since I updated to 2.6.39, my system has been crashing on a random basis,
> can someone identify what is going on here?
>
> I've checked the hardware it is OK and this only started to occur after I
> moved to 2.6.39 from what I can tell..
>
> Kernel crash/panic, hang:
> http://home.comcast.net/~jpiszcz/20110528/2639-ss1.jpg
> http://home.comcast.net/~jpiszcz/20110528/2639-ss2.jpg
>
> Kernel .config:
> http://home.comcast.net/~jpiszcz/20110528/config-2.6.39.txt
>
> Justin.

I've just had a very similar panic.

Here's a screenshot: http://dl.dropbox.com/u/3531548/panic.png

Daniel
