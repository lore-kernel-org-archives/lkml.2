Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2HMRpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:45:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63274 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2HMRpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120813170522.GG9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-4-git-send-email-js1304@gmail.com>
	<20120813163452.GB9180@google.com>
	<CAAmzW4P23=XDd6r1cJmz4R8Q4wotyhGx-6u=B=cmMofUj36Bng@mail.gmail.com>
	<20120813170522.GG9180@google.com>
Date: Tue, 14 Aug 2012 02:45:04 +0900
Message-ID: <CAAmzW4P_ahVJcUSoYJj277GXd7drW0Nu3FFmUeK25m86zzkBAg@mail.gmail.com>
Subject: Re: [PATCH 4/5] workqueue: use system_highpri_wq for highpri workers
 in rebind_workers()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14 Tejun Heo <tj@kernel.org>:
> On Tue, Aug 14, 2012 at 01:57:10AM +0900, JoonSoo Kim wrote:
>> > I think it would be better to just opencode system_wq selection in
>> > rebind_workers().
>>
>> Sorry for my poor English skill.
>> Could you elaborate "opencode system_wq selection" means?
>
> Dropping get_pool_system_wq() and putting the logic inside
> rebind_workers() directly.  I tend to dislike short helpers which are
> used only once.  They tend to obfuscate while not really contributing
> to anything else.

Okay!
I will send a next version which adopt your recommendation tomorrow.
