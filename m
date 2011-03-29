Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab1C2AMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:12:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35960 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1C2AMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:12:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [Q] PGPGIN underflow?
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D8C4953.8020808@kernel.dk>
References: <20110324095735.61bfa370.randy.dunlap@oracle.com> <4D8C4953.8020808@kernel.dk>
Message-Id: <20110329091252.C07A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 29 Mar 2011 09:12:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2011-03-24 17:57, Randy Dunlap wrote:
> > On Thu, 24 Mar 2011 10:52:54 +0900 (JST) KOSAKI Motohiro wrote:
> > 
> >> Hi all,
> >>
> >> Recently, vmstast show crazy big "bi" value even though the system has
> >> no stress. Is this known issue?
> >>
> >> Thanks.
> > 
> > underflow?  also looks like -3 or -ESRCH.
> > 
> > Adding Jens in case he has any idea about it.
> 
> First question, what does 'recently' mean? In other words, in what
> kernel did you first notice this behaviour?

Thans, Randy, Jens.
I dagged awhile and I've found this is -mm specific and known issue.
It was fixed by Hannes. (ref Message-ID: <20110324125316.GA2310@cmpxchg.org>)



