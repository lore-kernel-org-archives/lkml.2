Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1GEEkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:40:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64837 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1GEEj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E124D42.8040808@gmail.com>
References: <4E0D5E42.20702@gmail.com>
	<BANLkTinBJBnZbHPpdmnYX3EV0SYFd-pRDA@mail.gmail.com>
	<4E0D6B8D.6000601@gmail.com>
	<BANLkTimX4=Szn_JT49SLw4BvGxg3Qe0rYw@mail.gmail.com>
	<4E0ED42E.3020303@gmail.com>
	<4E113498.7050900@gmail.com>
	<CAD2nsn0XjoMUMv6e9SuSBUAwq0Lq5QCPMBWTnPZmsndg_XYcvw@mail.gmail.com>
	<4E124D42.8040808@gmail.com>
Date: Tue, 5 Jul 2011 10:09:57 +0530
Message-ID: <CAD2nsn2AhxWCT0XLn46n4GTE7-HOkT2HzKf6=6RsG3PbSB0hsw@mail.gmail.com>
Subject: Re: WARNING: at kernel/timer.c:1011 del_timer_sync+0xa9/0xc4()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
> FWIW below is my .config that I am using that seems to be having this
> warning message show up.
>
> latest pull of the Mainline dmesg:
>  http://fpaste.org/
>

hello Justin,

we doubt whether this patch is there in your linux-kernel tree you are
using, even though it is there in wireless-testing tree. please try to
apply this patch and see you can hit the warning
https://patchwork.kernel.org/patch/915952/

thanks,
shafi
