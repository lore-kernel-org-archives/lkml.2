Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab1FWMWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358Ab1FWMWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:22:44 -0400
Message-ID: <4E033004.90008@redhat.com>
Date: Thu, 23 Jun 2011 15:22:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] jump_label: fix jump_label update
References: <4E00038B.2060404@cn.fujitsu.com>
In-Reply-To: <4E00038B.2060404@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 05:35 AM, Xiao Guangrong wrote:
> The key of module is out of __stop___jump_table, it causes the events
> of modules does not work
>

What's the status of this patch?  I'm affected by this as well (I'm 
guessing the same module is involved).  I'm near the end of a bisect, 
but there's probably no point given this patch.

-- 
error compiling committee.c: too many arguments to function

