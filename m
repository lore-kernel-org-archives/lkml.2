Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab1CLQXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 11:23:37 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61081 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1CLQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 11:23:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tr1loEXAg/+CchCDuxdXs5xUXVWxQkb6Cvq6VpbndO5lZSoa4ACQGcenqoD4b+JRot
         YqzJP8OzbJY1Xu/zHNnRZuZ/hGYoSrUn5C87xfXT+IS4Ub93zXuShkwmWvle/kvk632S
         BqpcL/u8Hp2bp6h3SQoytzDpUulxAaV9nsx0Q=
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Mar 2011 18:23:33 +0200
Message-ID: <1299947013.17988.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 06:16 +0200, Maxim Levitsky wrote:
> Hi,
> 
> This is a repost of my patches for 2.6.39 inclusion, which I hope not to
> miss this time.
> 
> I addressed the comments on the scatterlist issues.
> 
> Andrew, please note that my richoh memstick driver is standalone, unchanged from previos versions
> has many users which use the version I posted at ubuntu's Launchpad and happy with it.
> Please include it regardless of other patches.
> 
> The other half of my work is support for legacy memorysticks which consists of 2 patches,
> first that adds few functions to scatterlist.c, and the other patch that adds the driver.
> Driver is also stable and tested.
> 
> Best regards,
> 	Maxim Levitsky


Any update?

Best regards,
	Maxim Levitsky

