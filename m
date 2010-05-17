Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0EQUxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:53:13 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:40802 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0EQUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:53:12 -0400
Message-ID: <4BF1AC51.7080108@nortel.com>
Date: Mon, 17 May 2010 14:51:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xianghua Xiao <xiaoxianghua@gmail.com>
CC: Con Kolivas <kernel@kolivas.org>,
       Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Issue with SCHED_FIFO app
References: <k2j54a292881005092139u7e120250hf530f8b688abdd22@mail.gmail.com>	 <t2s54a292881005092142h58ccae9ch2ecec665d06a7601@mail.gmail.com>	 <AANLkTillkVE9Mmz3CiQyIF5yiZfpp13g18UCyMQSuZ_K@mail.gmail.com>	 <201005131249.56432.kernel@kolivas.org> <AANLkTilGJ8VVFM5sUEP3ZXOSaUSeGpxui7NkuUPRpM_m@mail.gmail.com>
In-Reply-To: <AANLkTilGJ8VVFM5sUEP3ZXOSaUSeGpxui7NkuUPRpM_m@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 May 2010 20:53:07.0541 (UTC) FILETIME=[F3E04850:01CAF602]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 09:16 PM, Xianghua Xiao wrote:

> I'm unsure if the newest "top" (or /proc/PID/stat) reports the correct
> cpu usage when CFS/BFS is used, as you mentioned it seems failed to do
> that. I will try to stress the system and see who fails first under
> same workload, maybe that's the only way to compare cpu usage between
> 2.6.18rt vs 2.6.33rt, for now.

If you turn on scheduler debugging, then /proc/sched_debug gives
accurate information using the scheduler clock (at least with CFS, not
sure about BFS).

Chris
