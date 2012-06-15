Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2FOLLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:11:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42587 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2FOLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <1339478463-31172-1-git-send-email-amwang@redhat.com>
References: <1339478463-31172-1-git-send-email-amwang@redhat.com>
Date: Fri, 15 Jun 2012 19:11:12 +0800
Message-ID: <CAM_iQpUq39+VQMU6rq78iqpy2m-PnSwWUW4M3WYjpecVVv4jhw@mail.gmail.com>
Subject: Re: [PATCH] x86: revert "x86: Fix S4 regression"
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai.lu@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 1:21 PM, Cong Wang <amwang@redhat.com> wrote:
>
> Takashi, could you help to test if the S4 regression is still
> there after this patch?

Hello,

Any comments?

I have tested this revert on my laptop, with running simple
"suspend and resume" test for several times, I didn't see any
problem.

Thanks!
