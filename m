Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2IUN0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:26:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55867 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2IUN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:26:28 -0400
Message-ID: <505C6B03.7020305@gmail.com>
Date: Fri, 21 Sep 2012 15:26:27 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <5050CCE0.4090403@gmail.com> <20120919153934.GB2455@linux.vnet.ibm.com> <5059F458.3000407@gmail.com> <20120919170648.GF2455@linux.vnet.ibm.com> <505AC6C8.9060706@linux.vnet.ibm.com> <505AC979.7000008@gmail.com> <20120920152341.GE2449@linux.vnet.ibm.com> <505C33B9.8000807@gmail.com> <20120921121346.GD2458@linux.vnet.ibm.com>
In-Reply-To: <20120921121346.GD2458@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 02:13 PM, Paul E. McKenney wrote:
>> This might be unrelated, but I got the following dump as well when trinity
>> > decided it's time to reboot my guest:
> OK, sounds like we should hold off until you reproduce, then.

I'm not sure what you mean.

There are basically two issues I'm seeing now, which reproduce pretty much every
time:

 1. The "using when idle" warning.
 2. The rcu related hangs during shutdown.

The first one appears early on when I start fuzzing, the other one happens when
shutting down - so both of them are reproducible in the same session.


Thanks,
Sasha
