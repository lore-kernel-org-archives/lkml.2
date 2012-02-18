Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2BRNgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 08:36:17 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50411 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2BRNgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 08:36:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.52.99.42 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329548162.1753.13.camel@joe2Laptop>
References: <1329521976-1326-1-git-send-email-jorgyano@gmail.com>
	<20120218062534.GB2855@mwanda>
	<1329546625.1753.7.camel@joe2Laptop>
	<20120218064039.GD2912@mwanda>
	<1329548162.1753.13.camel@joe2Laptop>
Date: Sat, 18 Feb 2012 11:36:15 -0200
Message-ID: <CABRD5h+B-CzNQ+0+ahEBet7-N3O7Hh2BLQVwJzW7As_0UNs69w@mail.gmail.com>
Subject: Re: [PATCH 3/3] Staging: crystalhd: Replace the BCMLOG_ERR macro with pr_err
From: Jorgyano vieira <jorgyano@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        devel@linuxdriverproject.org, jarod@wilsonet.com, nsankar@broadcom.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's possible to add "%s...", __func__ to
> the necessary uses.  Adding it to the generic
> is likely overkill.
I agree with that.

> But is it really necessary anyway?
>
> Aren't those called via some specific notifier
> such that the output would make sense given
> some specific invalid input?
Some messages like "Invalid Arg" and "Invalid len" really don't make
sense as it is.

But I think that just adding __func__ to the necessary uses is enough.
I will resend this patch.
