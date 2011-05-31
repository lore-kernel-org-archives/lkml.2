Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab1EaUVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:21:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63080 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1EaUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UrmvYQr+Vt94+U3+Mk0HDpQUA1aBBxWvyRskvBSvPJTGYoxPoNP+z0n2W9v6s7UmzO
         gqL08jlmGzyfZb13EL5//7ZOqOJM0EkrV/l+s6KytveJGAHTNh9mAunLQq5toBPqJAeI
         Tp4WZh3mzP25iKHkKw+2PVt0gUAniOKzcYvPs=
MIME-Version: 1.0
In-Reply-To: <1306869046-20172-2-git-send-email-asharma@fb.com>
References: <1306869046-20172-1-git-send-email-asharma@fb.com> <1306869046-20172-2-git-send-email-asharma@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 31 May 2011 16:21:12 -0400
Message-ID: <BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com>
Subject: Re: [PATCH 2/2] atomic: move atomic_add_unless to generic code
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 15:10, Arun Sharma wrote:
> This is in preparation for more generic atomic
> primitives based on __atomic_add_unless.

i think you might have to have those primitives in place before this
patch makes sense.  the only thing this does is hoist a single
comparison out of arch atomic.h's and into linux/atomic.h.  this
savings alone looks simply like over engineering to me.
-mike
