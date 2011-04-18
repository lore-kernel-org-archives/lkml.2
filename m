Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1DRNZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:25:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37662 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1DRNZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TcugVOsBCwfQIf/OIBxFwTP9SJMeyYXdKIibYlraMFoLJJKXslw6D1TuFfHZwMkTwa
         pbR2qVvvg0NAfiQkaImQig5qaobyLUGr1OtGk03RLriuZKuDHRzZi6ytgsrIr+XpYEDK
         KzksnTV/lu8fMK/KSmqTNaPAelH10jGAtqgbw=
MIME-Version: 1.0
In-Reply-To: <20110418130441.GA29530@elte.hu>
References: <BANLkTi=kEvVCwxd=g65jBGTzmZD_KtT92w@mail.gmail.com>
	<20110418130441.GA29530@elte.hu>
Date: Mon, 18 Apr 2011 21:25:27 +0800
Message-ID: <BANLkTinV4JMAQpbo0TPA6q7q8b0JOTJ3qQ@mail.gmail.com>
Subject: Re: [PATCH] sched: remove hrtick_enabled()
From: Hillf Danton <dhillf@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 9:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Hillf Danton <dhillf@gmail.com> wrote:
>
>> The function, hrtick_enabled(), could be removed, since it is not used
>> anywhere, though defined.
>
> Well, what about kernel/sched_fair.c?
>
Yeah, the tricky is #include "sched-fair.c", though the removed is static.

Thanks,

          Hillf
