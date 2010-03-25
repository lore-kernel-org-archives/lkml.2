Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0CYIaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:30:16 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51774 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CYIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Eabjv5CoyuEsPq9p8rTKGZzJcdQnAfhDqrG7GyvaN6ExdySxuj5bI7tUBaoITlzmrR
         b3QlhpFwsKmSPIjIWzX97JF1qodI/j/i+VpjiDIV/Z7TqVxCPfoSF6zHgHDxWuUcOB3o
         RI3LiTLyfB48t4hMMTdQvrPP/vnnP8MmtCxa4=
MIME-Version: 1.0
In-Reply-To: <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
Date: Thu, 25 Mar 2010 09:30:12 +0100
Message-ID: <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: jassi brar <jassisinghbrar@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, dan.j.williams@intel.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/25 jassi brar <jassisinghbrar@gmail.com>:

> I too have been writing a driver for PL330 after taking into account the
> suggestions of Russell, Ben and other participants of the thread
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-February/009856.html
>
> If you don't think this driver conflicts with the theme of the thread,
> may I ask you to please put this driver on hold until you checkout my implementation
> of solution to the issue... which should be soon.

Please post the code as it looks today even if it's not compiling
instead of asking others
to hold their patches back. It will be obvious from what you have if
there is some special
use you're covering. Perhaps Joonyoung can simply port over the stuff
you need to
this driver if you show your code.

Yours,
Linus Walleij
