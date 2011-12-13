Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1LMSuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:50:44 -0500
Received: from mail.nonattached.net ([193.160.39.30]:58786 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1LMSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:50:43 -0500
Subject: Re: [PATCH] staging: wlan-ng: prism: coding style fixes, removed
 space-indentations
From: Dan Luedtke <mail@danrl.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 19:50:34 +0100
Message-ID: <1323802234.22324.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 13, 2011 at 7:27 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> Everyone's first patch is rejected, so don't feel bad.  :)  Btw put
> these kind of comments which you don't want in the permanent git log
> under the --- dashes.  git am removes that information.
Thanks for the feedback!  I'm glad I managed git send-email without
breaking up something, so no offense taken that the patch got rejected.

> It looks like you've tried to make everything aligned with the right
> hand side of the screen.  I think that's the first time I've seen
> someone do that.  I don't think it's normal.
Thank god! I am working on a kmodule, and the code looks awful that way.
I think I have to dig deeper into CodingStyle.txt

>> -----------------------------------------------------------------*/
>> +*----------------------------------------------------------------*/
>
> There is a normal kernel comment style described in Chapter 8 of
> Documentation/CodingStyle.
Now I am confused, as I understand multi-line comments should start
every line but the first with a *.
Anyway, one should commit code before bothering about comments, so I
silence myself here.

> Documentation/kernel-doc-nano-HOWTO.txt
Printed.

Again, thanks for the feedback! Will work on that and come back later
when I found something in the kernel to work on or when my module leaves
design-phase.

regards,
Dan

-- 
Dan Luedtke
http://www.danrl.de

