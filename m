Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1A3KZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 05:25:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab1A3KZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 05:25:55 -0500
Message-ID: <4D453CAC.4010305@redhat.com>
Date: Sun, 30 Jan 2011 18:25:48 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [Patch] rcupdate: remove dead code
References: <1296382988-16564-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1296382988-16564-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年01月30日 18:23, Amerigo Wang 写道:
> DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT, so #ifndef CONFIG_PREEMPT
> is totally useless in kernel/rcupdate.c.

By "useless" I meant the code under #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD,
of course. :)
