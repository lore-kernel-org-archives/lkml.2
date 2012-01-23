Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2AWEnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 23:43:33 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51185 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab2AWEnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 23:43:32 -0500
Message-ID: <4F1CE564.4050100@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 10:13:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Mantas <grawity@gmail.com>
CC: Srivatsa Bhat <srivatsasbhat@gmail.com>, maciej.rutecki@gmail.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, suspend-devel@lists.sourceforge.net
Subject: Re: 3.2-git - freeze during hibernation
References: <jepbo0$l1e$1@dough.gmane.org> <201201220905.10710.maciej.rutecki@gmail.com> <CAE368AS+FjoTvtBT0A2Qa0RXrJYbgxNdv6OOvD3cnmsTrLsRyQ@mail.gmail.com> <4F1C4F62.9060309@gmail.com>
In-Reply-To: <4F1C4F62.9060309@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12012218-9264-0000-0000-000000AE6232
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2012 11:33 PM, Mantas wrote:

> On 2012-01-22 10:32, Srivatsa Bhat wrote:
>> Could you please try the patch posted at:
>> https://lkml.org/lkml/2012/1/19/177 ?
> 
> Also tested linux git-v3.3-rc1 (currently latest); hibernation now works
> fine with the patch posted.
> 


I am glad that it works for you :)
Thanks a lot for testing!

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

