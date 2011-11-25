Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1KYUy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:54:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56098 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KYUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:54:56 -0500
Date: Fri, 25 Nov 2011 14:54:51 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com,
        Francois Romieu <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org,
        Armin Kazmi <armin.kazmi@tu-dortmund.de>, Gerd <booster@wolke7.net>
Subject: Re: [bug?] r8169: hangs under heavy load
Message-ID: <20111125205451.GG26692@elie.hsd1.il.comcast.net>
References: <4E7F4D45.7040902@wolke7.net>
 <1316978632.4122.103.camel@deadeye>
 <4E82C0B5.1050902@wolke7.net>
 <1317254171.4068.12.camel@deadeye>
 <20111124044137.GA18262@elie.hsd1.il.comcast.net>
 <4ECFE7A7.5070300@wolke7.net>
 <20111125201936.GA26692@elie.hsd1.il.comcast.net>
 <1322253122.2550.3.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322253122.2550.3.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> rtl8169_rx_interrupt(..., budget) can return budget + 1 sometimes
> because of :
>
>                 /* Work around for AMD plateform. */
>                 if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
>                     (tp->mac_version == RTL_GIGA_MAC_VER_05)) {
>                         desc->opts2 = 0;
>                         cur_rx++;
>                 }
>
> Sorry, I wont patch this today, its black Friday, and David said to
> patch submitters :
>
> "stick to turkey and wine you're better at it" 

:)  Sensible enough.  Thanks for the quick response!
