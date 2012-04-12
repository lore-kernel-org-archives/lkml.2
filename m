Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab2DLNvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:51:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39466 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741Ab2DLNvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:51:54 -0400
Message-ID: <4F86DDE9.70603@zytor.com>
Date: Thu, 12 Apr 2012 06:51:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com> <4F7F1659.5090305@zytor.com> <20120406201601.GA3310@p183.telecom.by> <4F7F59E1.2040009@zytor.com> <CACVxJT_RRfW7HknkbA4+41L9hNMBHZNezKs1ifbv_qFx5eB0-w@mail.gmail.com> <20120412121124.64aee2f6@pyramind.ukuu.org.uk> <CACVxJT-Yff7nw2Qd3WX8AbQ2259OgN_fgQ7TvgNMv8A=ysg2JA@mail.gmail.com>
In-Reply-To: <CACVxJT-Yff7nw2Qd3WX8AbQ2259OgN_fgQ7TvgNMv8A=ysg2JA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 06:35 AM, Alexey Dobriyan wrote:
> 
> You can't see I'm talking about difference only, can you?
> Have you read what hpa wrote exactly and what exactly I was answering to?
> 

He has and he is right.  You're trying to catch pointless corner cases.

	-hpa

