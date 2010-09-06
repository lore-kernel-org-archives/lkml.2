Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0IFL17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:27:59 -0400
Received: from t03.superonline.com ([92.45.6.173]:26844 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751911Ab0IFL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:27:57 -0400
Message-ID: <4C84D02A.7070508@superonline.com>
Date: Mon, 06 Sep 2010 07:27:38 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>, minchan.kim@gmail.com
Subject: Important news regarding the two different patches
References: <20100903105216.B65C.A69D9226@jp.fujitsu.com> <201009040344.42342.rjw@sisk.pl> <20100906090528.C8A9.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100906090528.C8A9.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -26.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/10 10:08 PM, KOSAKI Motohiro wrote:
>>> ok, thanks. probably I've catched your point. please feel free to use my reviewed-by
>>> for your fix.
>>
>> Thanks.
>>
>> In the meantime, though, I prepared a patch that should address the issue
>> entirely.  The patch is appended and if it looks good to you, I'd rather use it
>> instead of the previous one (it is still untested).
> 
> Yeah, this one looks nicer to me :)
> 
> Thanks, rafael!

Dear Rafael Wysocki, Kosaki Motohiro and Minchan Kim,

Upon Kosaki Motohiro's kind request via an off-list e-mail,
I tested the following two patches separately with a vanilla
2.6.35.4 kernel:

Patch 1:
	http://lkml.org/lkml/2010/9/5/86

Patch 2:
	http://kerneltrap.org/mailarchive/linux-kernel/2010/9/4/4615426

The first of these was prepared by Minchan Kim, and it fixes
the issue; i.e. no hangs during hibernation with a full tmpfs.

However, the second patch, prepared by Rafael Wysocki, does *not*
fix the problem. I still experience hangs with a full tmpfs upon
hibernation.

As always, I am willing to test newer patches and help in debugging
this issue.

I really appreciate all of your help,

M. Vefa Bicakci
