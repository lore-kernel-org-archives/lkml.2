Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab2DLOJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:09:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58499 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934315Ab2DLOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:09:34 -0400
Subject: Re: [PATCH] nextfd(2)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20120412121124.64aee2f6@pyramind.ukuu.org.uk>
References: <20120401125741.GA7484@p183.telecom.by>
	 <4F78D0BA.9040709@zytor.com>
	 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
	 <4F7F1659.5090305@zytor.com> <20120406201601.GA3310@p183.telecom.by>
	 <4F7F59E1.2040009@zytor.com>
	 <CACVxJT_RRfW7HknkbA4+41L9hNMBHZNezKs1ifbv_qFx5eB0-w@mail.gmail.com>
	 <20120412121124.64aee2f6@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Apr 2012 16:09:28 +0200
Message-ID: <1334239768.5300.6495.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 12:11 +0100, Alan Cox wrote:

> This whole thing is getting stupid. "Perfection is the enemy of
> success".
> 
> Your code will also fail when the cat pees on the computer, when the
> power fails and when disk dies. I suspect that other than the cat these
> are all more likely real world cases than your ENOMEM.

Time to open a thread on G+ and close this one I guess.


