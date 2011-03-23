Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1CWR5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:57:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1CWR5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=t8aJ5THkEmTyo/XN1P9HdF8AihwwySbN+MO/mtzLM95iduvhjIdMvioGaimZbzAa0X
         S8UK5KJE/hH/6EIb6YsUlGMq/5mZoCKiA6xO2mWwLmTLjqgFOSSwMy9YzjiHr7Po7VRx
         lKGyfcztgy9WMpUaZVaCpK1IK9ZTeBJ157X8Y=
MIME-Version: 1.0
In-Reply-To: <20110322111651.GE2351@sortiz-mobl>
References: <20110321122615.8a639909.sfr@canb.auug.org.au>
	<AANLkTikoF9fkZshaoop7gfuCKjjtUjbwwOG6hWyeGCHJ@mail.gmail.com>
	<20110322111651.GE2351@sortiz-mobl>
Date: Wed, 23 Mar 2011 18:57:43 +0100
X-Google-Sender-Auth: wkAP_tW5zPpWbfAlOkzPz1ZFa-w
Message-ID: <AANLkTikME5pB7t95wTLxcVOq_QK26bFZ3=zDpEz2wXWo@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/22 Samuel Ortiz <sameo@linux.intel.com>:

>> Fix looks correct, Sam if you push this to the MFD tree before
>> the pull request I'll be happy.
> I have just dropped 00423735a08e0d4030688496bca93f25c5e60111, since you were
> willing to carry it out after the MFD tree merge. Is that still your plan ?

Yes if Torvalds accepts that and the merge window isn't already
closed by then, else it will go for 2.6.40, no big deal.

Yours,
Linus Walleij
