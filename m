Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab0IRTXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:23:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59506 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab0IRTXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YKgPx4sKAIk0AO2xA1uMYDxc0Nqeli7vXAcFXDQi3U+geh5sbcKfv0+93zr4nE8JJn
         V3JUsuxsbH5v3UuyV8Dm7XA10/zi3KbNwMLGgYwJqNpWAbN+Jt7gPfaeSUK6v7PJllrR
         WJ9dUUnnBxtMg6pA+RkbhDUaVHTMsawarDTzs=
Subject: RE: PATA IDE is slower in newer versions of kernel
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Joshua Hintze <joshh@imsar.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <010901cb5754$ae6735a0$0b35a0e0$@com>
References: <00d401cb55f7$33a78210$9af68630$@com>
	 <20100917154732.330c4b1b@varda>  <010901cb5754$ae6735a0$0b35a0e0$@com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 21:22:54 +0200
Message-ID: <1284837774.12425.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 11:12 -0600, Joshua Hintze wrote:
> Some updated information. I created a screen capture of what I am seeing. First is the logic analyzer when the newer linux kernel is writing slow to the PATA port.
> 
> http://i56.tinypic.com/oqhrug.png
> 
> Notice in the above link how there is a lot of activating and then large gaps of no activity. After about 9 mS the STOP line is strobed a few times and then DMARQ finally returns to normal operating. The link below shows the picture of an old 2.6.10 kernel where write speeds are much faster.
> 
> http://i51.tinypic.com/a9wiur.png
> 
> In the above image notice how the wait time is considerable less 100's of microseconds before the stop lines get strobed.
> 
> I'm dedicated to continue working on the problem, I just need to advice from the linux community. I've tried different I/O schedulers such as noop and anticipatory and I'm studying the ide-dma code but still lost to where this is happening.
> 
> Thanks!
> 
Maybe you can just bisect this?
Just a general advice, I don't know ide subsystem at all.

Best regards,
	Maxim Levitsky

