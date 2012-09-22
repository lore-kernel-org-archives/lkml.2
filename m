Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2IVRuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 13:50:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45051 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab2IVRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 13:50:15 -0400
Message-ID: <505DFA65.3080805@gmail.com>
Date: Sat, 22 Sep 2012 19:50:29 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <505AC979.7000008@gmail.com> <20120920152341.GE2449@linux.vnet.ibm.com> <505C33B9.8000807@gmail.com> <20120921121346.GD2458@linux.vnet.ibm.com> <505C6B03.7020305@gmail.com> <20120921151203.GA2454@linux.vnet.ibm.com> <505C855F.3060301@gmail.com> <505D7621.4040505@gmail.com> <20120922150913.GA2934@linux.vnet.ibm.com> <505DDBE7.7010706@gmail.com> <20120922155613.GB2934@linux.vnet.ibm.com>
In-Reply-To: <20120922155613.GB2934@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 05:56 PM, Paul E. McKenney wrote:
> And now the prime suspect is the new CONFIG_RCU_USER_QS=y.  Do these
> warnings ever show up with CONFIG_RCU_USER_QS=n?

It seems that disabling that does make the warnings go away.

I'll keep the tests running in case it just reduces the chances or something
like that.


Thanks,
Sasha
