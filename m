Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1CHITc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:19:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64923 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1CHITa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:19:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ahpnKU84Pz4jmtAunlEL2QblJKEh+VllYJWoWjHjFWfWLB59OR3TkO+Jl8lOsQeQ4E
         0jpxlqmVUmepSbtMPucai9OS3sKAc2xEoX1QGNoxswgYs7SN8KXcmMec0ubHwxvFfVV/
         i9LjIyN5RIIYIXUK/EvUrjMvgzVFMUUE6iero=
MIME-Version: 1.0
In-Reply-To: <1299490414.14465.74.camel@marge.simson.net>
References: <1299486101.14465.25.camel@marge.simson.net>
	<AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	<1299490414.14465.74.camel@marge.simson.net>
Date: Tue, 8 Mar 2011 16:19:29 +0800
Message-ID: <AANLkTinPuCg-fGBtOgYSwVf1_67dr9uzw7a-8TfxLUuW@mail.gmail.com>
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 5:33 PM, Mike Galbraith <efault@gmx.de> wrote:
> Well, it does prevent complete death, but you have to be pretty darn
> attentive to notice that the patient is still technically alive ;-)
>
> As such, turning borrowing off by default, and making borrowing up to
> within a micron of 100% CPU an opt-in feature likely makes more sense.

Another idea comes into my head is: disable runtime borrowing for
root_task_group forever by default, but keep current behavior
for the sub-groups :)

Thanks,
Yong


-- 
Only stand for myself
