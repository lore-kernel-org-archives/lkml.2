Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1BNPnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:43:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33221 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab1BNPnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:43:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=b7XM7YqdjVYkNbO6HYMTEqlCAfDExoO0oJ5+ZVO7pwhB2HYHQJrX0UM967c0p8EOOn
         sYWZhdB40fBGq7cs5HUFWNnKj9IRhPmva9qdHWLqJ0PmzYsa+YXEern/4XA2F4fRXYql
         3Zfnb6mdfARnL4xgEc8/5sBfRueku7Vuk2aas=
MIME-Version: 1.0
In-Reply-To: <20110214154011.GA1595@flint.arm.linux.org.uk>
References: <20110207180606.GB2966@flint.arm.linux.org.uk>
	<AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com>
	<20110208125546.GA4286@flint.arm.linux.org.uk>
	<alpine.DEB.2.00.1102080856020.12521@router.home>
	<AANLkTimFDZFcO=J6PEOOo5RBdr0m7fjCKzWh1M_NaiLx@mail.gmail.com>
	<20110211091413.GA32687@flint.arm.linux.org.uk>
	<alpine.DEB.2.00.1102110920060.12360@router.home>
	<20110211153524.GB26188@flint.arm.linux.org.uk>
	<AANLkTimDUf52xdHn22=f1J=Xn88sqPEg9P6+ceas1h1k@mail.gmail.com>
	<20110214154011.GA1595@flint.arm.linux.org.uk>
Date: Mon, 14 Feb 2011 17:43:21 +0200
X-Google-Sender-Auth: Zo-JuQHjX-nujTA6lKweyt6Wf3M
Message-ID: <AANLkTin-i3+Pw8gW8c9AM2+6H1SsUgtqjvAYEv3Mi3HQ@mail.gmail.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
From: Pekka Enberg <penberg@kernel.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: ShiYong LI <a22381@motorola.com>, Christoph Lameter <cl@linux.com>,
        Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 5:40 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> Mainline only supports 32 byte and 64 byte cache lines on ARM.  It does
> not support 128 byte cache lines, so maybe your attempts are the wrong
> approach.  Can you please post your 128 byte cache line support patches
> to the ARM kernel mailing list for review.
>
> In the mean time, because your patch causes an oopsing regression, I
> strongly suggest that it is reverted until we start supporting 128 byte
> cache lines on ARM in mainline.

Agreed. I'll queue a revert. Thanks, Russell!
