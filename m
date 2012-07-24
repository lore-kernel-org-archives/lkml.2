Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2GXQZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:25:42 -0400
Received: from nm28-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.158]:46696 "HELO
	nm28-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755052Ab2GXQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:25:41 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2012 12:25:41 EDT
X-Yahoo-Newman-Id: 265519.97977.bm@smtp209.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iUz2nVgVM1m_B1Bl5koGbNt5lmCQSTqOFtbupFEjiuUUum7
 00oxAqm32dpqtaxBYQ9G8WdT918_JQ7vdBckwkVhvEORH0heclSGtRsM4Rp5
 pc2J7cD7r.DcsppLDPp2EeVcQkyZ1PG7sFx.A2JiFzQ4HGLUc9_x5Knr7gpz
 T48t.oqxx.xXiYcXvAzV7UeOiUyK3hEP27okB5J5ODX7frIDJ3t.SwgT2_Xh
 I8KA2J8RV76Mx4FSw6hUJUr7UagfZvKXdkU5a962H9AnjUqsoP7NCdFlFHQW
 x5GqLCBOjeYbcg6y73JkeN3Bk1a2NTU9qgJmTuZiKc7rjEPpKcIf6MHvnYhL
 lP6A.7.esFd2qyyvlOhxJwrODnX9FO.XQxQbxTzhKbI7mL1oyzTHCDFrS9cw
 zOTfzw0dhnrXIJETS0FjMUO0OeHmNLc5r.L2hkOo-
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 24 Jul 2012 11:18:51 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [SEGFAULT: perf]
Message-ID: <20120724161848.GA30762@ymail.com>
References: <20120723135214.GA14465@ymail.com>
 <878vea6mgf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vea6mgf.fsf@sejong.aot.lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung.

On Tue, Jul 24, 2012 at 09:18:24AM +0900, Namhyung Kim wrote:
> 
> (A) has a fix already in the tip tree [1], and maybe in mainline too.

Ah yes, I see the fix in 3.5 as well. Though it is slightly different
from the patch I submitted.

> And yes, I think this sort thing needs some love. It's on my TODO list
> but not have time to do it yet.

I understand all about time constraints. I am glad it is on your TODO 
though; will be on the lookout for commits on that front.

Cheers.

~ Andy
