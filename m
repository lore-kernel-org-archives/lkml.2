Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0IFCJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 22:09:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52542 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab0IFCJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 22:09:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com, "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <201009040344.42342.rjw@sisk.pl>
References: <20100903105216.B65C.A69D9226@jp.fujitsu.com> <201009040344.42342.rjw@sisk.pl>
Message-Id: <20100906090528.C8A9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Sep 2010 11:08:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ok, thanks. probably I've catched your point. please feel free to use my reviewed-by
> > for your fix.
> 
> Thanks.
> 
> In the meantime, though, I prepared a patch that should address the issue
> entirely.  The patch is appended and if it looks good to you, I'd rather use it
> instead of the previous one (it is still untested).

Yeah, this one looks nicer to me :)

Thanks, rafael!



