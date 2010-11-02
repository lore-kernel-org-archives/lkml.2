Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0KBVZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 17:25:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38536 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0KBVZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 17:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ScOh1ZA48OGAoA1RGVeApP0dJ95Zv+TOewLjQ+SEbARitXUmpmp3T5WpHilgRbiYP1
         3jVWA/wctyhx01a3C5BvjrFbOY6PlXk8rwk2/tQtRRXOfvO2/awCeBepY76y4LikBz1L
         8O610liNT0JEd0SeqtOhLoLB6+cGHAVXwnlbA=
MIME-Version: 1.0
In-Reply-To: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
Date: Tue, 2 Nov 2010 14:25:31 -0700
Message-ID: <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 11:18 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> Hi,
>       I was wondering what the long term implications of android development being forked from the linux mainline are?
>
> Android support was removed from 2.6.33 onwards, and development still continues for 2.6.35, by reverting the commit that deleted android from the mainline.
>
> One could argue that android gave linux a solid boost widespread adoption for mobile embedded devices, and its use would continue to grow exponentially with time, more than plain vanilla linux for embedded devices.
>
> Was removing android from the linux kernel mainline a mistake, in retrospect?
Might be your point is true but,if one see the amount of code that
went in main line or tried to push to main line is mere.Thats
unfortunate.

http://www.kroah.com/log/linux/android-kernel-problems.html

Regards,
Ram.
