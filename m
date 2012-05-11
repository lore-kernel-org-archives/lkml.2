Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030243Ab2EKLAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:00:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46979 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2EKLAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:00:32 -0400
MIME-Version: 1.0
In-Reply-To: <1336658058.2527.119.camel@twins>
References: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org> <CAE9FiQVu7KP=rabe5_jYZyEGpW7sv6wkK9wumJfW1vk2=+cYKA@mail.gmail.com>
 <1336650578.27020.94.camel@laptop> <1336651704.27020.100.camel@laptop> <1336658058.2527.119.camel@twins>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 13:00:11 +0200
Message-ID: <CA+1xoqfygHVK8hXqSOrZtudE57ZFut52Ptus9zwgBAJxH-VL_g@mail.gmail.com>
Subject: Re: [tip:sched/core] x86/numa: Check for nonsensical topologies on
 real hw as well
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 3:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> OK here's one that compiles and boots without silly warnings on a WSM-EP
>
>
> ---

I've tried Ingo's original patch on a KVM guest that has
'numa=fake=10', and saw two of these warnings mentioned above show up.

I've tried applying Peter's patch on top, but now I get 24 such
warnings instead.
