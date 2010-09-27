Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab0I0OlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:41:19 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53143 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab0I0OlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lErXvTeP2Yq1IHwNWf7lIbvOBc+YyXzUNOJHDW3MVYsXZqUzqfFu9TbyeATQkXKHQM
         vzL2Yy6BvZn7A/EVgX+KTD6BPBLYH92vrNqKNsxD8MBGt9wlsjwgIUIfl0CLVxF7+dLU
         w1pxT0LNzlGX8Kd765p5+iOOd0v+L1cPBOwM8=
MIME-Version: 1.0
In-Reply-To: <20100927134641.GA5456@nowhere>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
 <1285583997-1262-2-git-send-email-namhyung@gmail.com> <20100927134641.GA5456@nowhere>
From: Namhyung Kim <namhyung@gmail.com>
Date: Mon, 27 Sep 2010 23:40:49 +0900
Message-ID: <AANLkTim6P9oi2Ei54pzKSP1w8kJP3iQQ-VCp83RNT2C9@mail.gmail.com>
Subject: Re: [PATCH 1/5] perf: Wrap perf_lock_task_context using __cond_lock()
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 22:46, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> How do functions like mutex_lock_interruptible() that may
> or may not lock? I don't see __cond_lock adds there.
>

Hi,
AFAIK mutex code does not use such notations at all.


-- 
Regards,
Namhyung Kim
