Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1JXJBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:01:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48411 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1JXJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <4EA516C6.1010706@qq.com>
References: <1319440880-2610-1-git-send-email-cronozhj@gmail.com>
	<4EA516C6.1010706@qq.com>
Date: Mon, 24 Oct 2011 17:01:43 +0800
Message-ID: <CADqbE96pYFw2NSEKp9tuPPKHKP29i7VfL4k3jrxpcX-RQuGMjQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: MMU: initialize sptes early
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
>> Otherwise, the following kvm_sync_pages() will see invalid sptes in a new
>> shadow page.
>>
>
> No, kvm_sync_pages just handle the unsync page, but the new sp is the sync page.
>

Sorry, I didn't notice the sp itself was zero-ed when allocated hence
was considered as synced. Please ignore this patch.
Thanks for the remainder.
