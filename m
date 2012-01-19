Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab2ASUkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:40:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42380 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab2ASUkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:40:12 -0500
Message-ID: <4F187FA1.9090006@jp.fujitsu.com>
Date: Thu, 19 Jan 2012 15:40:01 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: venki@google.com
CC: kosaki.motohiro@gmail.com, akpm@linux-foundation.org, travis@sgi.com,
        srivatsa.bhat@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        rjw@sisk.pl, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
References: <4F171B6B.2040303@gmail.com> <1327003271-11730-1-git-send-email-venki@google.com>
In-Reply-To: <1327003271-11730-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2012 3:01 PM, Venkatesh Pallipadi wrote:
> Does this look better? Will send separate patch to fix code
> using num_possible_cpus() when they actually need nr_cpu_ids.

Sound ok to me. but I have two requests.

 - Please mesure how much time (or cycle) spented by cpumask_weight(cpu_possible_mask).
 - After your patch, nr_possible_cpus() return different value from before.
   Please verify this change doesn't makes any side effect.


