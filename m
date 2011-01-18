Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1ARWUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 17:20:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58961 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1ARWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 17:20:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MrPpMI5tiR59ueroZuf+saqbrPaQw/UmvwbMHn/4kap16x33ja5Y03cxF/CADs1dGA
         bje0UMxX84wjF4uDMZJ2FObzJD107DtyT/1F3fot5HSPCL2Nog84oXIT2iKnjDHQpsrY
         J4p4XSEgUtD7mhV+wyF8CnDxVP82HCcXixKbU=
MIME-Version: 1.0
In-Reply-To: <201101181759.32013.maciej.rutecki@gmail.com>
References: <20110111110539.GP24920@pengutronix.de>
	<201101181759.32013.maciej.rutecki@gmail.com>
Date: Wed, 19 Jan 2011 09:19:59 +1100
Message-ID: <AANLkTikC0ZV6pZ7jVmZ5DSrrkPCN4UPn3VY+zM2RWSc6@mail.gmail.com>
Subject: Re: BUG: spinlock recursion (sys_chdir, user_path_at, do_path_lookup ...)
From: Nick Piggin <npiggin@gmail.com>
To: maciej.rutecki@gmail.com
Cc: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/19 Maciej Rutecki <maciej.rutecki@gmail.com>:
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=27032
> for your bug report, please add your address to the CC list in there, thanks!

Sorry I missed this mail. This bug should have been fixed several
days ago 90dbb77ba48dddb87445d238e84cd137cf97dd98

Thanks for the report, please do again if you see any problems.
