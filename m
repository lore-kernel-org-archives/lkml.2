Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908Ab1IOUfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:35:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38503 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934787Ab1IOUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:35:40 -0400
Date: Thu, 15 Sep 2011 15:35:31 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Adam Baker <linux@baker-net.org.uk>
Cc: Greg KH <greg@kroah.com>, Leopold Palomo-Avellaneda <leo@alaxarxa.net>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that
 disables EPP support on many chipsets
Message-ID: <20110915203530.GA31345@elie>
References: <201109151441.15015.leo@alaxarxa.net>
 <20110915133555.GB16636@kroah.com>
 <20110915173950.GA19450@elie>
 <201109152123.07678.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109152123.07678.linux@baker-net.org.uk>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Baker wrote:

> The code has sat around for a long time because when I first posted the patch 
> I got no feedback to indicate if anyone else was suffering from the bug and if 
> anyone else had hardware that exhibited the bug it was supposed to fix so I 
> didn't want to pursue submitting it. Over the years I have seen occasional 
> reports of users suffering from the problem but I no longer have any EPP 
> hardware to test it on.
>
> That's why I posted the mail that said if someone else can verify the patch is 
> still useful I'm happy for it to be submitted with my signed off by on it

Makes sense.  Thanks for explaining and thanks for your work, Adam.
Actually I think 3 years before a patch gets the attention it deserves
is not so bad --- it was mostly that the problem has been known since
1999 that bothered me. :)
