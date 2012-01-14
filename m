Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2ANISi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 03:18:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48976 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab2ANISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 03:18:37 -0500
Message-ID: <4F113A50.1040303@gmail.com>
Date: Sat, 14 Jan 2012 16:18:24 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: dvhart@linux.intel.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, alan@linux.intel.com, tomoya.rohm@gmail.com,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing
 probe
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com> <20120114.001525.2158050844390627233.davem@davemloft.net>
In-Reply-To: <20120114.001525.2158050844390627233.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 04:15 PM, David Miller wrote:
> From: Darren Hart<dvhart@linux.intel.com>
> Date: Fri, 13 Jan 2012 22:44:55 -0800
>
>> CC: Jeff Kirsher<jeffrey.t.kirsher@intel.com>  (commit_signer:1/3=33%,commit_signer:1/8=12%)
>
> BTW, please try to figure out where this "commit_signer" stuff came from.
>
> It ended up corrupting the CC: list of your posting too.

It is from `./scripts/get_maintainer.pl`, and can be suppressed by 
adding '--norolestats' option. :)
