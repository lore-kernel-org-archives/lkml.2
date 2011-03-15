Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab1COUAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:00:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40592 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab1COUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZrDC6iO2u9eoFdQolAtFRbaWo6tLuJMuvogtaZeUhKFNIVMned6VeFAEyxZIuGqRIM
         Zg5FSmiJ0ChViD/QLvBDIrZAwWmfu4i3o8dPUUwQQivCCQBNoanxCa2aDn+V57L82p5i
         4gHnP07djZ/mj1fpR2vX0LSUv/t65JicxoB3M=
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <1299947013.17988.0.camel@maxim-laptop>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	 <1299947013.17988.0.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 22:00:10 +0200
Message-ID: <1300219210.13493.0.camel@MAIN>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-12 at 18:23 +0200, Maxim Levitsky wrote:
> On Fri, 2011-03-04 at 06:16 +0200, Maxim Levitsky wrote:
> > Hi,
> > 
> > This is a repost of my patches for 2.6.39 inclusion, which I hope not to
> > miss this time.
> > 
> > I addressed the comments on the scatterlist issues.
> > 
> > Andrew, please note that my richoh memstick driver is standalone, unchanged from previos versions
> > has many users which use the version I posted at ubuntu's Launchpad and happy with it.
> > Please include it regardless of other patches.
> > 
> > The other half of my work is support for legacy memorysticks which consists of 2 patches,
> > first that adds few functions to scatterlist.c, and the other patch that adds the driver.
> > Driver is also stable and tested.
> > 
> > Best regards,
> > 	Maxim Levitsky
> 
> 
> Any update?

Any update?


Best regards,
	Maxim Levitsky



