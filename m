Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab2EANqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:46:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46563 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab2EANqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204302248310.6271@ionos>
References: <20120430194725.763322463@linutronix.de> <20120430194846.862605948@linutronix.de>
 <4F9EF43C.3090608@gmail.com> <alpine.LFD.2.02.1204302238120.6271@ionos> <alpine.LFD.2.02.1204302248310.6271@ionos>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 09:46:17 -0400
Message-ID: <CAHGf_=p4+fBgZZh4v7-rou1h3kx12b6=uwtjdnh0PvA+R5WVaA@mail.gmail.com>
Subject: Re: [patch 21/29] score: Use generic init_task
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Chen Liqin <liqin.chen@sunplusct.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 4:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 30 Apr 2012, Thomas Gleixner wrote:
>> On Mon, 30 Apr 2012, KOSAKI Motohiro wrote:
>> > Almost patches delete arch specific init-task. But this patch doesn't.
>> > Is this really intentional?
>>
>> Not really. I missed it :( Will fix.
>
> Here is the updated one.
>
> Thanks,

Seems good. (but obviously I'm not score expert, don't believe me).

Thanks.
