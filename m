Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1HQCld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:41:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1HQClc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:41:32 -0400
Message-ID: <4E4B2A75.8010907@cn.fujitsu.com>
Date: Wed, 17 Aug 2011 10:41:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 5/8] cgroups: Ability to stop res charge propagation on
 bounded ancestor
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-6-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1311956010-32076-6-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 10:40:18,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-17 10:40:21,
	Serialize complete at 2011-08-17 10:40:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int res_counter_charge(struct res_counter *counter, unsigned long val,
> +			struct res_counter **limit_fail_at)
> +{
> +	return res_counter_charge_until(counter, NULL, val, limit_fail_at);
> +}
> +

static inline in res_counter.h ?

...
> +void res_counter_uncharge(struct res_counter *counter, unsigned long val)
> +{
> +	res_counter_uncharge_until(counter, NULL, val);
> +}
>  

ditto.
