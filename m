Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2DPJWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:22:06 -0400
Received: from nm34.bullet.mail.bf1.yahoo.com ([72.30.238.192]:23431 "HELO
	nm34.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753028Ab2DPJWD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:22:03 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 05:22:03 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 973363.4122.bm@omp1054.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MxB00L1Nk+vxzpiOqRg1Lwhxb6lZVg7hdteQrvg0DD8cwA75F0avC2oVGkfL46eASo6tSOx70Pb8MpC7U9P9P/i/7lnP8Dro8dEkHSzNOZz/GW/NskVW2DSRcLoSKQ71zMjM/OIiTfI+nVIEu8HxWEwPPnPts1+/2NLyUWnQbIA=;
X-YMail-OSG: zOOm7NIVM1lFzvANRy5hllwFlBIkIsufnr1w94NeVbtX8h3
 TjB3ToqELxhKMSkqyGHQLnNYD.GjmxdANpkA3N0LzoWgTf5naEQuASYyhiIj
 dK4loMw3rNST.vaobTdhllqIoto77.t7nCQs.pzCv5RZvfxq2NtPtWdSJipE
 SxgJ4fk3jXWFm4Omwf4rZfDoJ_L5q7u1L5DfdSTBfjhB9KnMSsqwuvvHweGf
 Dn7FugBCuVcBi__G2DkQgZzreHK7Z4Fwpc3Z9nPoGznL.r6a1EzT69nZ9BPN
 JwNSSyDmY7KvuXfH2oh42LKjMRZfL6mb9pXw09wLmL.DJ4iSH0Clgz.SMgqw
 43x7J0ceicDDOut2UnXUK2DfOGQxX4SNOeZ8JxeG0tglSg05T4BVg5Ndbe_v
 k88ZqjDthDR3iS1iiTBZ_HPP4P.OSsp9C1VBYPcqN13CqE106Vb4Jt5oPgL.
 DYl8UdFkxqGwa7i0dBsZaXWdCQGV4VXu9YjAM1.jzBQGVJDRUxrSWkq8-
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com> <CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com> <1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com> <CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com>
Message-ID: <1334567799.97554.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Mon, 16 Apr 2012 02:16:39 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
In-Reply-To: <CAFLxGvz5tmEi-39CZbJN+0zNd3ZpHXzZcNSFUpUWS_aMDJ4t6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: richard -rw- weinberger <richard.weinberger@gmail.com>
> Sent: Sunday, 15 April 2012 5:40 PM

> Every program which is allowed to use this interface will (ab)use it.
> Anyway, by exposing this interface to user space (or kernel modules)
> you'll confuse the VM system.

Dear Richard, thank you very much for all your feedbacks.
I can see that you forsee many problems in doing that (even as root) 
and in just one program as part of system utility.
I am sorry but if you can highlight few problems here it will be
helpful for me(and others) to understand.
Also I wanted to understand, why it is meant only for Hibernation?

Thank you so much !


Regards,
Pintu
