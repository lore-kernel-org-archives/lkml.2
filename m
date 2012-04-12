Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856Ab2DLTVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:21:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64685 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2DLTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:21:34 -0400
Date: Thu, 12 Apr 2012 22:21:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120412192125.GA3277@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
 <4F78D0BA.9040709@zytor.com>
 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
 <4F7F1659.5090305@zytor.com>
 <20120406201601.GA3310@p183.telecom.by>
 <4F7F59E1.2040009@zytor.com>
 <CACVxJT_RRfW7HknkbA4+41L9hNMBHZNezKs1ifbv_qFx5eB0-w@mail.gmail.com>
 <20120412121124.64aee2f6@pyramind.ukuu.org.uk>
 <CACVxJT-Yff7nw2Qd3WX8AbQ2259OgN_fgQ7TvgNMv8A=ysg2JA@mail.gmail.com>
 <4F86DDE9.70603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F86DDE9.70603@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 06:51:37AM -0700, H. Peter Anvin wrote:
> He has and he is right.  You're trying to catch pointless corner cases.

For the record, the only objection I find real is about
sequential vs bulk nature of the system call.
