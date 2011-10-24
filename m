Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1JXJER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:04:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47148 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1JXJEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <4EA517D7.6060407@qq.com>
References: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
	<1319440880-2610-2-git-send-email-cronozhj@gmail.com>
	<4EA517D7.6060407@qq.com>
Date: Mon, 24 Oct 2011 17:04:14 +0800
Message-ID: <CADqbE94FN1h2=pwAAB4Ry3Z3+4uRaTnA6PD3c-hAjw5pOzqtSQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: MMU: fix the condition of syncing a new shadow page
From: Zhao Jin <cronozhj@gmail.com>
To: Xiao Guangrong <xiao.guangrong@qq.com>
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/24 Xiao Guangrong <xiao.guangrong@qq.com>:
> On 2011/10/24 15:21, Zhao Jin wrote:
>> Should be "or" since a new shadow page is synced if either it is
>> not leaf or there already exists another unsync shadow page with
>> the same gfn.
>>
>
> It is obviously wrong, we need to sync pages only if it has unsync page
> *and* the new shadow page breaks the unsync rule(only the level 1 sp can
> became unsync).
>

Please ignore this patch as I had taken an incorrect assumption.
Thanks very much for the correction.
