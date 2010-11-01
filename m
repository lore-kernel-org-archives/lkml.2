Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab0KAQO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:14:59 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53474 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab0KAQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:14:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ey/1G+Io4p5zpy12SXjg5GOXCgjrgB8sh0wltknBfVjw+B9QhGqf1i4VuLC1NBzRwk
         BL+6hbvg2cembE23mhE3WiVw2UkOD9PvOtSAfgC+aUSBW7GulzSdLD1HTEAZaxdBEwgB
         Nnhf7p+DKGBx63CS3mORfeGcB7/aCBLsajJ3g=
MIME-Version: 1.0
In-Reply-To: <20101101.085126.71102684.davem@davemloft.net>
References: <AANLkTikQuUcAMZKqZ3Rz5HVzOs+63-Y4VYUo5-3EM30H@mail.gmail.com>
	<20101102023650.bc553e74.sfr@canb.auug.org.au>
	<AANLkTin3nsb6FfNtXfqjZCuV66mwKVOsKgmZpTABFDUJ@mail.gmail.com>
	<20101101.085126.71102684.davem@davemloft.net>
Date: Mon, 1 Nov 2010 12:14:55 -0400
Message-ID: <AANLkTi=MDPMXOPpvHXCBmEAWkRDcZN1u5h3H7J+ptrMq@mail.gmail.com>
Subject: Re: All Applied micro boards are failing with current mainline kernel
From: Josh Boyer <jwboyer@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, rsarmah@apm.com, therbert@google.com,
        eric.dumazet@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 11:51 AM, David Miller <davem@davemloft.net> wrote:
>> I can whip up a patch to remove those calls or move them after the
>> register, but I don't want to do that without knowing which one is
>> "right".
>
> I've already taken care of this.

Thanks!

josh
