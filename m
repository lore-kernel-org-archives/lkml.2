Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0JYKEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:04:48 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6134 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571Ab0JYKEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:04:47 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o9PA636M004893
Subject: Re: On Linux numbering scheme
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Tejun Heo <htejun@gmail.com>, kevin granade <kevin.granade@gmail.com>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <234909.335371287999912985.JavaMail.root@mail-zbox20.bo3.lycos.com>
References: <234909.335371287999912985.JavaMail.root@mail-zbox20.bo3.lycos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 12:04:38 +0200
Message-ID: <1288001078.17570.24.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 05:45 -0400, Artem S. Tashkinov wrote:
[....] 
> That's my point. "2.6" prefix is totally meaningless nowadays. I just

Only if you ignore the first 10(?) years of the Linux kernel.

> want to rejuvenate the numbering scheme and make it easy to understand
> and comprehend. What's the difference between .16 and .36? Besides, I

`diff -urN` will show. SCNR ...
What' the difference between 2010-3 and 2010-11?
Hooray, 8 months.
But what does that really tell us?
Nothing about the released item. And we loose the information if there
were other releases in between.

> just think these huge numbers look unsightly. Do you know any other
> piece of software which has the same huge numbers?

Yes, those that use years (and months) in their release numbering
scheme.
And no, because they release so often new "major" releases that they are
thus inherently unstable and buggy. SCNR ...

It makes absolutely no sense to use any version numbering (or naming) as
such as an indicator for anything - except *within the very same
project* to keep the releases in chronological order - both for humans
and software/scripts/tools/.....
Relying on release numbers for QA (or similar issues) is not a good
idea.

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at


