Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0HIQdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:33:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37763 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab0HIQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Pf5yldZd6JRirotQid0062trR6PE4Vc3TV45ueY/q0JwjpKy758xl88ebrikOav0Ji
         MVjXeoNV5i62hQyA+uMrO6PlmhdL8eIh6r8wyR46dFAAEv1pv+E+yvqjNUEBxTJZnpCL
         5vMXlVjPqKmBAaNxdGs9j+O0EAOITd4VRLqk0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
Date: Mon, 9 Aug 2010 09:33:32 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.33.6-147.2.4.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: Vadim Zaliva <lord@crocodile.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org> <9D74DA20-E3C8-43BC-B529-82605F64637F@crocodile.org> <1281325390.2168.64.camel@pasglop>
In-Reply-To: <1281325390.2168.64.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008090933.32446.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 08, 2010 08:43:09 pm Benjamin Herrenschmidt wrote:
> On Sun, 2010-08-08 at 18:24 -0700, Vadim Zaliva wrote:
> > I have tested the patch on device I had
> > I will have an access to it to retest later thus week. We can wait for my
> > test to try to identify how my PowerBook is different from yours. Or you
> > can roll the patch back.
> 
> I'd rather roll the patch back for now. I'll send the revert as part of
> the next powerpc update. We'll sort things out then.

I'll be sending pull request to Linus this evening and should take care of
this as well. I guess we need to pull it out of stable as well since Vadim's
thouchpad was usable even with older code but some touchpads are completely
broken now.

We can re-instate the fix later when we make sure it works fr everyone.

Thanks.

-- 
Dmitry
