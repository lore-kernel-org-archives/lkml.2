Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0DWDsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:48:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0DWDsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:48:12 -0400
Message-ID: <4BD118E2.7080307@cn.fujitsu.com>
Date: Fri, 23 Apr 2010 11:49:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] memcg rcu lock fix in swap code (Was Re: [BUG]
 an RCU warning in memcg
References: <4BD10D59.9090504@cn.fujitsu.com> <20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100423121424.ae47efcb.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 23 Apr 2010 11:00:41 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> with CONFIG_PROVE_RCU=y, I saw this warning, it's because
>> css_id() is not under rcu_read_lock().
>>
> 
> Ok. Thank you for reporting.
> This is ok ? 

Yes, and I did some more simple tests on memcg, no more warning
showed up.

> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
