Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab1DHURC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:17:02 -0400
Received: from mail.aknet.ru ([78.158.192.28]:38603 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab1DHURB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:17:01 -0400
Message-ID: <4D9F6D08.8050002@aknet.ru>
Date: Sat, 09 Apr 2011 00:16:08 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4D9EE899.5040109@aknet.ru> <20110408185531.GA3697@redhat.com>
In-Reply-To: <20110408185531.GA3697@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08.04.2011 22:55, Oleg Nesterov wrote:
> Why do you check thread_group_leader() ???? What if the caller is not
> the leader?
>
> I told this many times, and I got lost. If you reparent, you should
> always reparent the whole group.
Arrgh, OK, hope I realize that now, sorry! There were lots of other
problems, so I was constantly forgetting about this one. Or,
maybe, I couldn't get away with the fact that any sub-thread
can reparent the whole group. OK, will definitely fix this time. :))
Thanks!
