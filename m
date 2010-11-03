Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0KCKSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40357 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab0KCKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qSTLlFX/KVgL6F77ed+LRxaGUiz+rruEeSeTIKvO0aHbBXTh8Rj/YP8h6fktAy+NpI
         AebMlye0ocOM4I8yVR8IKj15a6ydfuW4yEhyl++/dnfwWJ3jxT+LQ0eDxDWbxGXFSRdl
         1dd2D8S78QYtqN6gWtfqYmZtYoq+6o7PuNK2o=
MIME-Version: 1.0
In-Reply-To: <956998.65651.qm@web180302.mail.gq1.yahoo.com>
References: <1288124308-14999-9-git-send-email-cyril@ti.com>
	<956998.65651.qm@web180302.mail.gq1.yahoo.com>
Date: Wed, 3 Nov 2010 11:18:37 +0100
Message-ID: <AANLkTin=3K0H+YdNM2Nhz63c3+Upp+rwApo-Ww4p5qH6@mail.gmail.com>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        Cyril Chemparathy <cyril@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/3 David Brownell <david-b@pacbell.net>:

> That seems like
> a better structure for various vendors' "SSP"
> hardware (multifunction serial interface logic)

Incidentally the ARM PrimeCell PL022 is called SSP,
"Synchronous Serial Port" and is not multifunction at all.
Just to add to the confusion...

Yours,
Linus Walleij
