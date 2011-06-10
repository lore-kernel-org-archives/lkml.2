Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1FJHw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:52:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40135 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1FJHwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:52:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1CD47.10906@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 16:52:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: tglx@linutronix.de, rientjes@google.com, linux@arm.linux.org.uk,
        dbaryshkov@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mel@csn.ul.ie, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com,
        pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>	<BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com>	<BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com>	<alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>	<20110601181918.GO3660@n2100.arm.linux.org.uk>	<alpine.LFD.2.02.1106012043080.3078@ionos>	<alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com>	<alpine.LFD.2.02.1106012134120.3078@ionos>	<4DF1C9DE.4070605@jp.fujitsu.com> <20110610004331.13672278.akpm@linux-foundation.org>
In-Reply-To: <20110610004331.13672278.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 16:43), Andrew Morton wrote:
> On Fri, 10 Jun 2011 16:38:06 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
>> Subject: [PATCH] Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not configured"
> 
> Confused.  We reverted this over a week ago.

Oh, I'm sorry. I missed it. Please forget my stupid mail.



