Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0IYMwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 08:52:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33375 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0IYMwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 08:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZoIkMaqF2Z/n2tj3jZ3hGkxqZ72P6uoTeFvxMjYYRO/hOnP/NVKaR/pStNJjg5gtMK
         wHadBnBDPxYKipbF6t0h3EqgcxzlfapfBgajMu05pWAnZG2rQKEaOXPaLqWirphtfwza
         kzG7RvXewtmx4OAm9DyGy2HA4WYJQmj3uKKnQ=
MIME-Version: 1.0
In-Reply-To: <1285417423.2478.475.camel@edumazet-laptop>
References: <1285406495-20080-1-git-send-email-namhyung@gmail.com>
 <1285407727.2478.288.camel@edumazet-laptop> <AANLkTimD2zfLoYrXARs2dNHq7XEjpuVgCxEXEp-qm2Go@mail.gmail.com>
 <1285417423.2478.475.camel@edumazet-laptop>
From: Namhyung Kim <namhyung@gmail.com>
Date: Sat, 25 Sep 2010 21:51:59 +0900
Message-ID: <AANLkTimDmV+AMFz_TNodEob9zuZf+oAySaRv975izL+m@mail.gmail.com>
Subject: Re: [PATCH] signal: annotate siglock acquisition
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 21:23, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> #define lock_task_sighand(t, flags)                     \
>        __cond_lock(&(t)->sighand->siglock,             \
>                    _raw_lock_task_sighand(t, flags))
>

Looks great! Will use it in a new patch.
Many thanks.


-- 
Regards,
Namhyung Kim
