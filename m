Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab2IXXGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:06:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53638 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2IXXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <5060E498.7030003@gmail.com>
References: <20120921121346.GD2458@linux.vnet.ibm.com>
	<505C6B03.7020305@gmail.com>
	<20120921151203.GA2454@linux.vnet.ibm.com>
	<505C855F.3060301@gmail.com>
	<505D7621.4040505@gmail.com>
	<20120922150913.GA2934@linux.vnet.ibm.com>
	<505DDBE7.7010706@gmail.com>
	<20120922155613.GB2934@linux.vnet.ibm.com>
	<505DFA65.3080805@gmail.com>
	<20120922212735.GG2934@linux.vnet.ibm.com>
	<20120923002105.GA1112@linux.vnet.ibm.com>
	<505EA09B.6040105@gmail.com>
	<CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
	<5060E31B.3070203@gmail.com>
	<5060E498.7030003@gmail.com>
Date: Tue, 25 Sep 2012 01:06:02 +0200
Message-ID: <CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
Subject: Re: RCU idle CPU detection is broken in linux-next
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/25 Sasha Levin <levinsasha928@gmail.com>:
> On 09/25/2012 12:47 AM, Sasha Levin wrote:
>>  - While I no longer see the warnings I've originally noticed, if I run with Paul's last debug patch I see the following warning:
>
> Correction: Original warnings are still there, they just got buried in the huge spew that was caused by additional debug warnings
> so I've missed them initially.

Are they the same? Could you send me your dmesg?

Thanks.
