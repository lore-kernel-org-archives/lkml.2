Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1EWTpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:45:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab1EWTph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=k3jm4iKwmwJ59HobSIDBaum0lFhg821UJ/FnRsmPYNifuZMKyuLQgtAZqhFlslsTMQ
         +SFAClfnYApIhRDVRYcA==
MIME-Version: 1.0
In-Reply-To: <1305806316.2466.7221.camel@twins>
References: <1305674470-23727-1-git-send-email-john.stultz@linaro.org>
	<1305806316.2466.7221.camel@twins>
Date: Mon, 23 May 2011 12:45:32 -0700
X-Google-Sender-Auth: tTLRQHPddY8Qs5dmx1zqx_ZsadY
Message-ID: <BANLkTikPs35QJk7q8MtWaSq9fBKbYSJ4bA@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched: Fix min_vruntime calculation in dequeue_entity
From: Dima Zavin <dima@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

My apologies for the very delayed response, mail filter fail.

Your patch looks equivalent to what we use today, so...

Acked-by: Dima Zavin <dima@android.com>


On Thu, May 19, 2011 at 4:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-05-17 at 16:21 -0700, John Stultz wrote:
>> While Dima never replied publicly, I bugged him a few weeks ago
>> and he said that this fix should address his original issue.
>
> Should or does? :-)
>
> I was really hoping for a tested-by tag..
>
