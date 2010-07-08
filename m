Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0GHGOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:14:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56252 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0GHGOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qeIsCzzdU5zQEF3mLbha6Gkbf/Gcz6Qd6Kb5fgsqZQS2gStIEwOyEBqbSYQHfy93n/
         ZUPDzu/sFDo3SfGiKQpy717uHaqpuFlS/U6lemIqRDnxzEmky7SIqPSRj32PCVXmyfME
         fp/jJwlal+Gx+79Qimc8rAkFQ36/lRD/gfgjU=
Date: Wed, 7 Jul 2010 23:14:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: werner@guyane.yi.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
Message-ID: <20100708061413.GA3747@core.coreip.homeip.net>
References: <1278563108.9127@guyane.yi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278563108.9127@guyane.yi.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 01:25:08AM -0300, werner@guyane.yi.org wrote:
> 2.6.35-rc2,3,3-git1 -- Problem with PS2 keyboard and mouse driver
> 
> That problem continues at 2.6.35-rc4-git2 .
> 
> Since 2.6.35-rc2 the USB keyboard driver don't work longer, on different mainboards and keyboards.
> 
> On 2.6.35-rc1 things still were (more or less) normal.
> 
> THIS IS AN ERROR WHICH ENTERED BETWEEN 2.6.35 -rc1 and -rc2 !!
> 

Hm, I am confused.., which one does not work? PS/2? USB? Both? Can you
long in over the network?

Please post your full dmesg and .config (the ones you have posted are
incomplete, do you have 'quiet' on the kernel command line or
something?).

Thanks.

-- 
Dmitry
