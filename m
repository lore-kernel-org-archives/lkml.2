Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab1FPNKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:10:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59775 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1FPNKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jHPrl4tZ3QRnKLu01bPHXXH7OMsxSArrIJgUUXgcuGSzuUume1VeNcLsFCFtdgA4hg
         qeCElPnblah5fFPc3Ug9mO7pdU1TIrAIYaB4VP3eIRUcx94od+NZpykd/8C8ruWCN33a
         Zf+5BJ/kNu1pABzm3tGniZS+HOMNpi9JV1iN0=
MIME-Version: 1.0
In-Reply-To: <20110223204108.GA6327@infomag.iguana.be>
References: <20110223204108.GA6327@infomag.iguana.be>
Date: Thu, 16 Jun 2011 15:10:06 +0200
Message-ID: <BANLkTimM+9__P4jpvuEL0zDFCyzPX=MrmA@mail.gmail.com>
Subject: Re: [RFC] [PATCH 0/10] Generic Watchdog Timer Driver
From: Andrea Galbusera <gizero@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

On Wed, Feb 23, 2011 at 9:41 PM, Wim Van Sebroeck <wim@iguana.be> wrote:
> To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.
>
> This framework/API consists of the following patches:
> part  1: Introduction of the WatchDog Timer Driver Core
> part  2: Add the basic ioctl functionality
> part  3: Add the WDIOC_KEEPALIVE ioctl
> part  4: Add the WDIOC_SETOPTIONS ioctl
> part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> part  6: Add orphan control
> part  7: Add the Magic Close feature
> part  8: Add the nowayout feature
> part  9: Add support for a miscdev parent device
> part 10: Add support for extra ioctl calls

While looking for efforts to provide a generic driver for gpio driven
watchdog devices, like some simple hardware supervisors, I came into
this patchset RFC, which turned out to be very interesting to me.
Maybe I'm looking into the wrong places, but I could not find any
upstream commit after this RFC.
Since I don't see any real critic from commenters to the approach you
are suggesting, I'd like to know if there still is some
work-in-progress on this.

TIA
Kind regards,

Andrea
