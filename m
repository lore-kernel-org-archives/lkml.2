Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0LXHrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 02:47:40 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:23749 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0LXHrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 02:47:39 -0500
Message-ID: <4D145016.60906@free.fr>
Date: Fri, 24 Dec 2010 08:47:34 +0100
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Iceowl/1.0b2 Icedove/3.1.7
MIME-Version: 1.0
To: Felipe Balbi <me@felipebalbi.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, lud <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
References: <Pine.LNX.4.44L0.1012231755180.11535-100000@netrider.rowland.org> <36f50535272fab60e974dc75e172bf29@secure211.sgcpanel.com>
In-Reply-To: <36f50535272fab60e974dc75e172bf29@secure211.sgcpanel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/12/2010 00:56, Felipe Balbi wrote:
> Hi,

> I've got an E6400 myself and the only time I could get
> it to hang was when trying to use brcm80211 driver from
> staging. The problem appears when I rmmod/modprobe the
> driver after it looses connection to my wifi router.
>
> Since the driver is still in staging and buggy as hell
> I didn't bother notifying anyone. But it's true that
> shutdown truly hangs.
>
> Are you using brcm80211 driver too ?
>

No. Mine has an Intel WiFi chipset. With DELL the same reference can be 
used for multiple different hardware instantiation (I have a nvidia vido 
chipset some seems now to have an intel one).

PS: For me the hang appeared with 2.6.37-rc7. I run linux on it for more 
than a year changing stable kernel as soon as they appear and usually 
trying future kernel around rc6 stage.

2.6.36.2 works perfectly. I did not change my config except maybe if the 
make oldconfig was proposing something obvious (e.g new generic MII 
support).

--eric
