Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1AKL0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:26:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab1AKL0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:26:13 -0500
Message-ID: <4D2C3E4D.3070307@redhat.com>
Date: Tue, 11 Jan 2011 19:26:05 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>	<m1bp3uifln.fsf@fess.ebiederm.org>	<AANLkTinLhAuSny735kofonAkaqwJvjjDHMUed_r03rVc@mail.gmail.com>	<m1k4igjwzf.fsf@fess.ebiederm.org>	<1294432333.3237.107.camel@localhost.localdomain>	<m18vywh1g7.fsf@fess.ebiederm.org>	<1294447189.3237.132.camel@localhost.localdomain> <m1k4ieesky.fsf@fess.ebiederm.org>
In-Reply-To: <m1k4ieesky.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年01月09日 10:09, Eric W. Biederman 写道:
>
> We aren't dealing with modules I think CAP_SYS_MODULE is totally
> irrelevant in the context of kexec.


Yeah, although I don't really understand CAP_SYS_MODULE, but it
really confused me to add it to kexec_load() from its name.

>
> I think to accomplish what you want we either need a way to disable
> sys_kexec_load or possibly a new very targeted capability bit.
>
> You are making it so that giving someone CAP_SYS_MODULE is giving more
> than the ability to load kernel modules.  Which seems non-intuitive from
> a system management point of view.
>

How about CAP_SYS_KEXEC?

Thanks.
