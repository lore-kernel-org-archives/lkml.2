Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2IXWyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:54:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34024 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2IXWyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:54:03 -0400
Message-ID: <5060E498.7030003@gmail.com>
Date: Tue, 25 Sep 2012 00:54:16 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <20120921121346.GD2458@linux.vnet.ibm.com> <505C6B03.7020305@gmail.com> <20120921151203.GA2454@linux.vnet.ibm.com> <505C855F.3060301@gmail.com> <505D7621.4040505@gmail.com> <20120922150913.GA2934@linux.vnet.ibm.com> <505DDBE7.7010706@gmail.com> <20120922155613.GB2934@linux.vnet.ibm.com> <505DFA65.3080805@gmail.com> <20120922212735.GG2934@linux.vnet.ibm.com> <20120923002105.GA1112@linux.vnet.ibm.com> <505EA09B.6040105@gmail.com> <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com> <5060E31B.3070203@gmail.com>
In-Reply-To: <5060E31B.3070203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 12:47 AM, Sasha Levin wrote:
>  - While I no longer see the warnings I've originally noticed, if I run with Paul's last debug patch I see the following warning:

Correction: Original warnings are still there, they just got buried in the huge spew that was caused by additional debug warnings
so I've missed them initially.
